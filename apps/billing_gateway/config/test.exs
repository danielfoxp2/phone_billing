use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :billing_gateway, BillingGatewayWeb.Endpoint,
  http: [port: 4001],
  server: false

config :billing_gateway, :http_client, BillingGateway.Dummy.HttpClient

# Print only warnings and errors during test
config :logger, level: :warn

