use Mix.Config

config :billing_gateway, BillingGatewayWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "peaceful-coast-39242.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secrete_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :logger, level: :info