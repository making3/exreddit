use Mix.Config

config :exreddit,
  username: System.get_env("REDDIT_USER"),
  password: System.get_env("REDDIT_PASS"),
  client_id: System.get_env("REDDIT_CLIENT_ID"),
  secret: System.get_env("REDDIT_SECRET"),
  api_rate_limit_delay: 1000
