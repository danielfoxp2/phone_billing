use Mix.Config

config :billing_gateway, BillingGatewayWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "peaceful-coast-39242.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [port: {:system, "PORT"}],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :logger, level: :info

config :billing_gateway, :http_client, BillingGateway.HttpClient