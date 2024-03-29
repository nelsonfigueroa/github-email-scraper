# GitHub Email Scraper

Scrape contributor emails from a GitHub repository.

## Note

I found a better way of doing this with a CLI command instead of this Ruby script: https://nelson.cloud/scrape-contributor-emails-from-any-git-repository/

tldr: just run this command within a git directory:

```shell
git shortlog -sea | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" | awk '{print tolower($0)}' | sort | uniq | grep -wv 'users.noreply.github.com'
```

## Motivation

I noticed that the GitHub API exposes email addresses used in commits. I wanted to see how easily someone could scrape for emails using a script. I talk about GitHub email scraping and protecting yourself in a [blog post](https://nelson.cloud/scraping-github-contributor-emails/).

## Disclaimer

This was created for demonstrational purposes. What you do with this script or emails gathered is purely your responsibility.

## Usage

This script uses the API endpoint as defined here: https://docs.github.com/en/rest/reference/repos#commits

*Note that GitHub limits unauthenticated API calls to 60 per hour.*

*Rate limting info: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting*


You'll need Ruby installed on your system. Then run:

```
ruby main.rb -u <github-username> -r <github-repository> -p <commit-page>
```

To see instructions directly in the command line, run:

```
$ ruby main.rb -h

Usage: example.rb [options]
    -u, --username=USERNAME          Specify GitHub username
    -r, --repository=REPOSTORY       Specify GitHub repository
    -p, --page=PAGE                  Specify the commit page to begin scraping from
```

## Examples

A regular scraping operation would look like this. If you do not specify `-p`, the scraper will begin from page 1. The rate limit will be exceeded on large repositories:

```
$ ruby main.rb -u torvalds -r linux

	+-------------------+
	|   GitHub          |
	|       Email       |
	|         Scraper   |
	+-------------------+


Scraping https://github.com/torvalds/linux/
Rate limit exceeded.
Pages scraped: 1-58 out of 10447
43 emails written to torvalds-linux.txt

```

An example that specifies the page of commits to begin scraping from:

```
$ ruby main.rb -u torvalds -r linux -p 100

	+-------------------+
	|   GitHub          |
	|       Email       |
	|         Scraper   |
	+-------------------+


Scraping https://github.com/torvalds/linux/
Rate limit exceeded.
Pages scraped: 100-159 out of 10447
39 emails written to torvalds-linux.txt
```

An example where the IP address is rate limited:

```
$ ruby main.rb -u torvalds -r linux

	+-------------------+
	|   GitHub          |
	|       Email       |
	|         Scraper   |
	+-------------------+


Scraping https://github.com/torvalds/linux/
Error, got status code 403
Response message:
API rate limit exceeded for <your_IP>. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)
```
