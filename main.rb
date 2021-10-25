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
end

parser.parse!

if options.empty?
  # show help if no arguments passed in
  puts parser
  exit
end

if !options['username'] || !options['repository']
  puts 'Missing argument.'
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

scraper = Scraper.new(options['username'], options['repository'])
scraper.scrape_emails
scraper.output_emails
