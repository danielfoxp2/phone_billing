defmodule BillingProcessor.CallRecordsProcessor do

  def get_only_valid(call_records) do
    grouped_valid_call = group_only_valid(call_records)
    {grouped_valid_call, call_records}
  end
  
  def execute({call_records_inserted, all_call_records}) do
    %{
      received_records: Enum.count(all_call_records),
      consistent_records: Enum.count(call_records_inserted, fn {status, _call_record} -> status == :ok end),
      inconsistent_records: Enum.count(all_call_records, fn call_record -> call_record["errors"] != nil end)
    }
  end

  defp group_only_valid(call_records) do
    Enum.filter(call_records, fn call_record -> call_record["errors"] == nil end)
    |> Enum.group_by(fn call_record -> call_record["call_id"] end)
  end
  
end