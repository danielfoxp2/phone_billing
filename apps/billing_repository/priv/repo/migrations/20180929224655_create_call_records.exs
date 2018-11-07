defmodule BillingRepositoy.Repo.Migrations.CreateCallRecords do
  use Ecto.Migration

  def change do
    create table(:call_records, primary_key: false) do
      add :id, :string, primary_key: true
      add :type, :string
      add :timestamp, :string
      add :call_id, :integer
      add :source, :string
      add :destination, :string

      timestamps()
    end

  end
end
