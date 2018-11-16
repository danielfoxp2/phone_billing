defmodule BillingProcessor.CallRecordsProcessor do

  def get_only_valid(call_records) do
    grouped_valid_call = group_only_valid(call_records)
    {grouped_valid_call, call_records}
  end
  
  def execute({call_records_inserted, all_call_records}) do
    %{
      received_records_quantity: Enum.count(all_call_records),
      consistent_records_quantity: Enum.count(call_records_inserted, fn {status, _call_record} -> status == :ok end),
      inconsistent_records_quantity: Enum.count(all_call_records, fn call_record -> call_record["errors"] != nil end),
      database_inconsistent_records_quantity: Enum.count(call_records_inserted, fn {status, _call_record} -> status == :error end),
      failed_records_on_validation: Enum.filter(all_call_records, fn call_record ->  call_record["errors"] != nil end),
      failed_records_on_insert: Enum.filter(call_records_inserted, fn {status, _call_record} -> status == :error end)
    }
  end

  defp group_only_valid(call_records) do
    Enum.filter(call_records, fn call_record -> call_record["errors"] == nil end)
    |> Enum.group_by(fn call_record -> call_record["call_id"] end)
  end
  
end