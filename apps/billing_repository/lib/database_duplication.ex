defmodule BillingRepository.DatabaseDuplication do
  alias BillingRepository.Repo
  use Task

  def search_for(call_records) do
    call_records
    |> Enum.map(fn call_record -> Task.async(fn -> get_duplicated(call_record) end) end)
    |> Enum.flat_map(&Task.await/1)
  end

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