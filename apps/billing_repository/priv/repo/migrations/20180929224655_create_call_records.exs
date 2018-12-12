defmodule BillingRepositoy.Repo.Migrations.CreateCallRecords do
  use Ecto.Migration

  def change do
    create table(:call_records, primary_key: false) do
      add :id, :string, primary_key: true
      add :type, :string
      add :timestamp, :timestamp
      add :call_id, :bigint
      add :source, :bigint
      add :destination, :bigint
    end

  end
end
