defmodule BillingRepository.CallRecordRepository do
  alias BillingRepository.Calls.CallRecord
  alias BillingRepository.Repo
  alias Ecto.Multi

  def insert_only_valid(grouped_calls) do
    grouped_calls
    |> Enum.map(fn {_not_used, call} -> Task.async(fn -> insert_data_of(call) end) end)
    |> Enum.map(&Task.await/1)
  end

  def insert_data_of(call) do
    [first_call_record | [second_call_record]] = call

    Multi.new()
    |> Multi.run(:start_call, fn _ -> insert(first_call_record) end)
    |> Multi.run(:end_call, fn _ -> insert(second_call_record) end)
    |> Repo.transaction()
  end

  def insert(call_record) do
    %CallRecord{}
    |> CallRecord.changeset(call_record) 
    |> Repo.insert()
  end

end