# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :exreddit,
  username: System.get_env("REDDIT_USER"),
  password: System.get_env("REDDIT_PASS"),
  client_id: System.get_env("REDDIT_CLIENT_ID"),
  secret: System.get_env("REDDIT_SECRET"),
  api_rate_limit_delay: 1000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
