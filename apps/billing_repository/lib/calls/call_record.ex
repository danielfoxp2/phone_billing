defmodule BillingRepository.Calls.CallRecord do
  use Ecto.Schema
  import Ecto.Changeset


  schema "call_records" do
    field :call_id, :integer
    field :destination, :string
    field :source, :string
    field :timestamp, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(call_record, attrs) do
    call_record
    |> cast(attrs, [:id, :type, :timestamp, :call_id, :source, :destination])
    |> validate_required([:id, :type, :timestamp, :call_id, :source, :destination])
  end
end
