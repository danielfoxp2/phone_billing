defmodule BillingRepository.Repo.Migrations.CreateTariffs do
  use Ecto.Migration

  def change do
    create table(:tariffs, primary_key: false) do
      add :reference, :int, primary_key: true
      add :standing_charge, :float
      add :call_charge, :float
    end
  end
end
