# exreddit

Exreddit is a Reddit API Wrapper.

## Installation

Until further development, add the following to Hex:

```elixir
def deps do
  [
    {:exreddit, git: "https://github.com/making3/exreddit.git", branch: "master"}
  ]
end
```

## Usage

    token = ExReddit.OAuth.get_token()
    subreddit = "learnprogramming"
    options = [limit:1]

    ExReddit.Api.get_new_threads(token, subreddit, options)
