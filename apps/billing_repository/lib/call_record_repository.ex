defmodule BillingRepository.CallRecordRepository do
  alias BillingRepository.Calls.CallRecord
  alias BillingRepository.Repo

  def insert_only_valid(call_records) do
    call_records
    |> Enum.map(fn call_record -> Task.async(fn -> insert_data_of(call_record) end) end)
    |> Enum.map(&Task.await/1)
  end

  def insert_data_of(call_record) do
    %CallRecord{}
    |> CallRecord.changeset(call_record)
    |> Repo.insert()
  end

end