# GitHub Email Harvester

Harvest contributor emails from a GitHub repository.

## Disclaimer

This was created for demonstration purposes. What you do with this script or emails gathered is purely your responsibility.

## Usage

This script uses the API endpoint as defined here: https://docs.github.com/en/rest/reference/repos#commits
*Note that GitHub limits unauthenticated API calls to 60 per hour.*
*Rate limting info: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting*


You'll need Ruby installed on your system. Then run:

```bash
ruby scraper.rb
```

The script is interactive. You'll be asked for a GitHub username and associated repository. After the script is done, it will output emails in a textfile named `{{username}}-{{repository}}.txt`.

## Example

A regular scraping operation would look like this. The rate limit will be exceeded on large repositories:

```
$ ruby main.rb

+-------------------+
|   GitHub          |
|       Email       |
|         Scraper   |
+-------------------+

Enter a GitHub username:
torvalds
Enter a repository:
linux
Scraping https://github.com/torvalds/linux/
Rate limit exceeded.
Pages scraped: 59 out of 10447
44 emails written to torvalds-linux.txt

```

If your current IP address is already rate limited, you'll run into this:

```
$ ruby main.rb

+-------------------+
|   GitHub          |
|       Email       |
|         Scraper   |
+-------------------+

Enter a GitHub username:
torvalds
Enter a repository:
linux
Scraping https://github.com/torvalds/linux/
Error, got status code 403
Response message:
API rate limit exceeded for <your-ip>. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)
```