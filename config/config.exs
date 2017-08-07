# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cookery,
  ecto_repos: [Cookery.Repo]

# Configures the endpoint
config :cookery, CookeryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8ex0vJ5kPTAnJYNI4uxWZwOAWcqZz2/B3hmn8/DRen682hSIR6SEyjV0K0U0nCPL",
  render_errors: [view: CookeryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookery.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
