defmodule BillingRepository.DatabaseDuplication do
  alias BillingRepository.Repo
  use Task

  @doc """
  Get the duplicated call records based on id and call id.

  ## Parameters

    A list with of call records

  ## Examples without duplication

      iex> call_records = [%{ "id" => "1", "call_id" => "1", "type" => "start" }, %{ "id" => "2", "call_id" => "1", "type" => "end" }]
      iex> DatabaseDuplication.search_for(call_records)
      {[], [%{ "id" => "1", "call_id" => "1", "type" => "start" }, %{ "id" => "2", "call_id" => "1", "type" => "end" }]}
  """
  def search_for(call_records) do
    duplicated_call_records_found = search_in_parallel_for_duplicated(call_records)
    {duplicated_call_records_found, call_records}
  end

  defp search_in_parallel_for_duplicated(call_records) do
    call_records
    |> Enum.map(fn call_record -> Task.async(fn -> get_duplicated(call_record) end) end)
    |> Enum.flat_map(&Task.await/1)
  end

  defp get_duplicated(%{"id" => id, "call_id" => nil}), do: get_duplicated(%{"id" => id, "call_id" => 0})
  defp get_duplicated(%{"id" => id, "call_id" => ""}), do: get_duplicated(%{"id" => id, "call_id" => 0})
  defp get_duplicated(%{"id" => id, "call_id" => call_id}) do
    Ecto.Adapters.SQL.query!(Repo, get_duplicated_query(id, call_id))
    |> mount_result
  end
  defp get_duplicated(%{"id" => id}) do
    get_duplicated(%{"id" => id, "call_id" => 0})
  end
  defp get_duplicated(%{"call_id" => call_id}) do
    get_duplicated(%{"id" => 0, "call_id" => call_id})
  end
  defp get_duplicated(_call_record), do: get_duplicated(%{"id" => 0, "call_id" => 0})

  defp get_duplicated_query(id, call_id) do
    """
    select id, null call_id from call_records
    where id = '#{id}'
    union
    select null id, call_id from call_records
    where call_id = #{call_id}
    """
  end

  defp mount_result(%Postgrex.Result{rows: rows}) do
    rows 
    |> Enum.flat_map(fn [id | call_id] -> duplicated_keys(id, call_id) end)
  end

  defp duplicated_keys(id, [nil]), do: [id: id]
  defp duplicated_keys(nil, call_id), do: [call_id: List.first(call_id)]

end