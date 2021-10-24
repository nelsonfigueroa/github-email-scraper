# frozen_string_literal: true

require_relative 'scraper'

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

scraper = Scraper.new(username, repository)
scraper.scrape_emails
scraper.output_emails
