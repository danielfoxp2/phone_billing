defmodule BillingRepository.Protocol do
  alias BillingRepository.Repo
  
  @moduledoc """
    Creates a protocol number to identify the chunk of call records processed. 
  """

  @doc """
  Generate a new protocol number

  ## Examples

      iex> Protocol.new_number()
      3
  """
  def new_number() do
    Ecto.Adapters.SQL.query!(Repo, "select nextval('protocol_seq')")
    |> get_number()
  end

  defp get_number(%Postgrex.Result{rows: rows}) do
    rows
    |> Enum.flat_map(fn row -> row end)
    |> List.first
  end
  
end
