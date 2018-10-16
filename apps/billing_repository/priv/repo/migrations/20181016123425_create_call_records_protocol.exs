defmodule BillingRepository.Repo.Migrations.CreateCallRecordsProtocol do
  use Ecto.Migration

  def change do
    execute "create sequence protocol_seq"
  end
end
