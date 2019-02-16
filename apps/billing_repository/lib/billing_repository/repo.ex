defmodule BillingRepository.Repo do
  @moduledoc false
  use Ecto.Repo, 
  otp_app: :billing_repository,
  adapter: Ecto.Adapters.Postgres
end