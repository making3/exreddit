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

### Configuration

It is recommended to create the following environment variables for configuring your user:

- `REDDIT_USER`
- `REDDIT_PASS`
- `REDDIT_CLIENT_ID`
- `REDDIT_SECRET`



Otherwise, in config/config.exs, add the following:

    config :exreddit,
      username: "username",
      password: "password",
      client_id: "client_id",
      secret: "client_secret"

## Usage

    token = ExReddit.OAuth.get_token()
    subreddit = "learnprogramming"
    options = [limit:1]

    ExReddit.Api.get_new_threads(token, subreddit, options)

## Development

### Tests

Use mix test to run tests. Application variables need to be setup in order to run api tests.

    mix test
    mix test --exclude reddit_api   # Exclude api tests
    mix test --only subreddit       # Only subreddit tests
