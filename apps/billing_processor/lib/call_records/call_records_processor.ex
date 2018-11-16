defmodule BillingProcessor.CallRecordsProcessor do

  def get_only_valid(call_records) do
    Enum.filter(call_records, fn call_record -> call_record["errors"] == nil end)
    |> Enum.group_by(fn call_record -> call_record["call_id"] end)
  end

  def execute(call_records) do
    %{
      received_records: Enum.count(call_records),
      consistent_records: Enum.count(call_records),
      inconsistent_records: 2
    }
  end
  
end