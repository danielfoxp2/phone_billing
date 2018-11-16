defmodule BillingProcessor.CallRecordsProcessor do

  def get_only_valid(call_records) do
    grouped_valid_call = group_only_valid(call_records)
    {grouped_valid_call, call_records}
  end
  
  def execute({call_records_inserted, all_call_records}) do
    %{
      received_records_quantity: Enum.count(all_call_records),
      consistent_records_quantity: Enum.count(call_records_inserted, &where_everything_is_ok/1),
      inconsistent_records_quantity: Enum.count(all_call_records, &which_contains_errors/1),
      database_inconsistent_records_quantity: Enum.count(call_records_inserted, &which_contains_errors/1),
      failed_records_on_validation: Enum.filter(all_call_records, &which_contains_errors/1),
      failed_records_on_insert: Enum.filter(call_records_inserted, &which_contains_errors/1)
    }
  end

  defp group_only_valid(call_records) do
    Enum.filter(call_records, fn call_record -> call_record["errors"] == nil end)
    |> Enum.group_by(fn call_record -> call_record["call_id"] end)
  end

  defp where_everything_is_ok({status, _not_used}), do: status == :ok
  
  defp which_contains_errors({status, _in_call_record}), do: status == :error
  defp which_contains_errors(in_call_record), do: in_call_record["errors"] != nil
  
end