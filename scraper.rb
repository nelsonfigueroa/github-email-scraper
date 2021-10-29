# frozen_string_literal: true

require 'net/http'
require 'json'

class Scraper
  def initialize(username, repository, page)
    @emails = []
    @username = username
    @repository = repository
    @page = page || 1 # in the event that page is not provided, default to 1
    @starting_page = page
    @last_page = 0
    @uri = "https://api.github.com/repos/#{username}/#{repository}/commits?per_page=100&page=#{page}"
  end

  def scrape_emails
    puts "Scraping https://github.com/#{@username}/#{@repository}/"

    loop do
      response = Net::HTTP.get_response(URI(@uri))

      # check for other errors, such as rate limiting or nonexistent repository
      if response.code != '200'
        puts "Error, got status code #{response.code}"
        puts 'Response message:'
        puts JSON.parse(response.body)['message']
        exit
      end

      # if response body is blank, that means the current page exceeds the last page (user error)
      if response.body == '[]'
        puts 'Page exceeds final page of commits for repository.'
        exit
      end

      # get the last page so we don't loop past it
      @last_page = response['Link'].split(',')[1].split('=')[2].split('>')[0].to_i if @last_page.zero?

      # don't go past the last page
      break if @page > @last_page

      # convert to array of hashes
      json_response = JSON.parse(response.body)

      json_response.each do |commit|
        @emails << commit['commit']['author']['email']
      end

      # if this is the last request available to us, break out of the loop
      if response['X-RateLimit-Remaining'].to_i.zero?
        puts 'Rate limit exceeded.'
        if @emails.empty?
          puts 'No emails scraped.'
          exit
        end
        break
      end

      @page += 1
    end
  end

  def output_emails
    # output file
    filename = "#{@username}-#{@repository}.txt"
    file = File.open(filename, 'w')

    @emails.uniq!

    output_emails = []

    @emails.each do |email|
      # filter out github emails @noreply.github.com
      next if email =~ /noreply.github.com/

      output_emails << email
    end

    file.puts(output_emails)
    file.close

    puts "Pages scraped: #{@starting_page}-#{@page} out of #{@last_page}"
    puts "#{output_emails.count} emails written to #{filename}"
  end
end
