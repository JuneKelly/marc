# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :marc, Marc.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oy/+55Q8HBL98e4E2E609J4mB4gtP1QFaBN3GQ2xWM3zwvwlqessn5cMKLaRzOL0",
  render_errors: [view: Marc.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Marc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
