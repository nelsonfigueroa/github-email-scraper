# frozen_string_literal: true

require 'net/http'
require 'json'

puts '
+-------------------+
|   GitHub          |
|       Email       |
|         Scraper   |
+-------------------+                                                   
'

puts 'Enter a GitHub username:'
username = gets.chomp

puts 'Enter a repository:'
repository = gets.chomp

emails = []

page = 1
last_page = 0

uri = "https://api.github.com/repos/#{username}/#{repository}/commits?per_page=100&page=#{page}"
puts uri

loop do
  response = Net::HTTP.get_response(URI(uri))

  if response.code != '200'
    puts "Error, got status code #{response.code}"
    puts response.body
    exit
  end

  last_page = response['Link'].split('&page=').last.split('>').first.to_i if last_page.zero?

  json_response = JSON.parse(response.body) # convert to array of hashes

  json_response.each do |commit|
    emails << commit['commit']['author']['email']
  end

  puts response.code
  puts response['X-RateLimit-Remaining'].to_i

  if response['X-RateLimit-Remaining'].to_i.zero?
    puts 'Rate limit exceeded.'
    if emails.empty?
      puts 'No emails scraped.'
      exit
    end
    break
  end

  break if page == last_page

  page += 1
end

# output file
filename = "#{username}-#{repository}.txt"
file = File.open(filename, 'w')

emails.uniq!

# filter out github emails @noreply.github.com
output_emails = []

emails.each do |email|
  next if email =~ /noreply.github.com/

  output_emails << email
end

file.puts(output_emails)
file.close

puts "#{output_emails.count} emails written to #{filename}"
