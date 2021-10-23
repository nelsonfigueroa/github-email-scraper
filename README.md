# GitHub Email Harvester

Harvest contributor emails from a GitHub repository.

## Disclaimer

This was created for demonstration purposes. What you do with this script or emails gathered is purely your responsibility.

## Usage

This script uses the API endpoint as defined here: https://docs.github.com/en/rest/reference/repos#commits
*Note that GitHub limits unauthenticated API calls to 60 per hour.*
*Rate limting info: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting*


Ruby installation required. Then run:

```bash
ruby scraper.rb
```

The script is interactive. You'll be asked for a GitHub username and associated repository. After the script is done, it will output emails in a textfile named `{{username}}-{{repository}}.txt`.
