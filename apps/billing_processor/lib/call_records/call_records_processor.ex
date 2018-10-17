defmodule BillingProcessor.CallRecordsProcessor do

  def execute(call_records) do
    %{received_records: Enum.count(call_records)}
  end
  
end