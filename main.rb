# frozen_string_literal: true

require 'optparse'
require_relative 'scraper'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = 'Usage: example.rb [options]'

  opts.on('-u', '--username=USERNAME', 'Specify GitHub username') do |u|
    options['username'] = u
  end

  opts.on('-r', '--repository=REPOSTORY', 'Specify GitHub repository') do |r|
    options['repository'] = r
  end

  opts.on('-p', '--page=PAGE', 'Specify the commit page to begin scraping from') do |p|
    p = p.to_i # if a string is input, this will convert to 0
    if p <= 0
      p = 1 # we want to start at page 1
    end
    options['page'] = p
  end
end

parser.parse!

if options.empty?
  # show help if no arguments passed in
  puts parser
  exit
end

unless options['username']
  puts 'Missing username argument.'
  puts parser
  exit
end

unless options['repository']
  puts 'Missing repository argument.'
  puts parser
  exit
end

puts '
	+-------------------+
	|   GitHub          |
	|       Email       |
	|         Scraper   |
	+-------------------+

	'

scraper = Scraper.new(options['username'], options['repository'], options['page'])
scraper.scrape_emails
scraper.output_emails
