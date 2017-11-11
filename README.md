# ExReddit

Exreddit is a Reddit API Wrapper.

## Example

    token = ExReddit.OAuth.get_token()
    subreddit = "learnprogramming"
    options = [limit:1]

    {:ok, threads} = ExReddit.Api.get_new_threads(token, subreddit, options)

## Installation

Add the following to Hex:

```elixir
def application do
  [
    applications: [:exreddit]
  ]
end

def deps do
  [
    {:exreddit, git: "https://github.com/making3/exreddit.git", branch: "master"}
  ]
end
```

### Configuration

    config :exreddit,
      username: System.get_env("REDDIT_USER"),
      password: System.get_env("REDDIT_PASS"),
      client_id: System.get_env("REDDIT_CLIENT_ID"),
      secret: System.get_env("REDDIT_SECRET"),
      api_rate_limit_delay: 1000      # In milliseconds


It is recommended to create the following environment variables for configuring your user:

- `REDDIT_USER`
- `REDDIT_PASS`
- `REDDIT_CLIENT_ID`
- `REDDIT_SECRET`

## Usage

    token = ExReddit.OAuth.get_token()
    subreddit = "learnprogramming"
    options = [limit:1]

    {:ok, threads} = ExReddit.Api.get_new_threads(token, subreddit, options)

## Development

### Tests

Use mix test to run tests. Application variables need to be setup in order to run api tests.

    mix test
    mix test --exclude reddit_api   # Exclude api tests
    mix test --only subreddit       # Only subreddit tests
