use Mix.Config

# Configure your database
config :billing_repository, BillingRepository.Repo,
  username: "postgres",
  password: System.get_env("PHONE_BILLING_DB_ENV_POSTGRES_PASSWORD"),
  database: "phone_billing_db_dev",
  hostname: System.get_env("PHONE_BILLING_DB_PORT_5432_TCP_ADDR"),
  pool_size: 10