defmodule BillingRepository.Calls.CallRecord do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "call_records" do
    field :id, :string, primary_key: true
    field :call_id, :integer
    field :destination, :integer
    field :source, :integer
    field :timestamp, :utc_datetime
    field :type, :string
  end

  @doc false
  def changeset(call_record, attrs) do
    call_record
    |> cast(attrs, [:id, :type, :timestamp, :call_id, :source, :destination])
    |> validate_required([:id, :type, :timestamp, :call_id])
  end
end
