# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :github,
  ecto_repos: [Github.Repo]

config :github, Github.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# # Secret key. You can use `mix guardian.gen.secret` to get one
config :github, GithubWeb.Auth.Guardian,
  issuer: "github",
  secret_key: "pc/OfCvXR4sK4858INV8BmjoqXGDzg/Km0N4bJLVcBbK+sUerPaLtf6yp0w/IXRE"

config :github, GithubWeb.Auth.Pipeline,
  module: GithubWeb.Auth.Guardian,
  error_handler: GithubWeb.Auth.ErrorHandler

# Configures the endpoint
config :github, GithubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nQF/s1XDzsZA6YMG7fCKzXcIxtFy2b+Y77A4fkUHncvZU7eDnngSHNPMO4XM2TpI",
  render_errors: [view: GithubWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Github.PubSub,
  live_view: [signing_salt: "Buj8buIE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
