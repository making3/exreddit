# exreddit

Exreddit is a Reddit API Wrapper.

## Installation


## Usage

    token = ExReddit.OAuth.get_token()
    subreddit = "learnprogramming"
    options = [limit:1]

    ExReddit.Api.get_new_threads(token, subreddit, options)
