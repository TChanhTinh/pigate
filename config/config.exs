# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pigate,
  ecto_repos: [Pigate.Repo]

# Configures the endpoint
config :pigate, PigateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kFyFTVlJ0QRpRFRf4NprXUfpfPq4HsBDq7p3YPIftbNtDP2hjMk8Egz0OPTMWswd",
  render_errors: [view: PigateWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Pigate.PubSub,
  live_view: [signing_salt: "E0hd5MWQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
