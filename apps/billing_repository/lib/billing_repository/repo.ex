defmodule BillingRepository.Repo do
  use Ecto.Repo, 
  otp_app: :billing_repository,
  adapter: Ecto.Adapters.Postgres
end