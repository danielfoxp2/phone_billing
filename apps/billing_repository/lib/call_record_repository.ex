defmodule BillingRepository.CallRecordRepository do
  import Ecto.Query
  alias BillingRepository.Calls.CallRecord
  alias BillingRepository.Repo
  alias Ecto.Multi
  
  @moduledoc """
  Responsible for manage the persistence of call records that will be used in bill calculation
  """

  @doc """
  Insert validated call records.

  ## Parameters

    A tuple with the following structure:

    - grouped_calls: Validated call records to be inserted.
    - call_records: All call records. It is used to maintain a returning contract in the flow of call records management.

  ## Examples

      iex> grouped_calls = %{"1" => [%{"id" => "3", "call_id" => "1", "type" => "start"}, %{"id" => "4", "call_id" => "1", "type" => "end"}]}

      iex> call_records = [
      > %{"id" => "1", "errors" => "error_message"}, 
      > %{"id" => "2", "errors" => "error_message"}, 
      > %{"id" => "3", "call_id" => "1", "type" => "start"}, 
      > %{"id" => "4", "call_id" => "1", "type" => "end"}
      > ]

      iex> CallRecordRepository.insert_only_valid(grouped_calls, call_records)
      {[], call_records}
  """
  def insert_only_valid({grouped_calls, call_records}) do
    insertion_result = insert_in_parallel(grouped_calls)
    {insertion_result, call_records}
  end

  @doc """
  Get the persisted calls for the given phone number and reference period.

  ## Parameters

    A map with the following structure:

    - phone_number: A integer with ten or eleven digits.
    - reference_period: A String in the format `"MM/yyyy"`.

  ## Examples

      iex> parameters = %{ "phone_number" => 62984680648, "reference_period" => "02/2019" }
      iex> CallRecordRepository.get_calls(parameters)
      %{"1" => [%{"id" => "3", "call_id" => "1", "type" => "start"}, %{"id" => "4", "call_id" => "1", "type" => "end"}]}
  """
  def get_calls(%{"phone_number" => phone_number, "reference_period" => <<month::bytes-size(2)>> <> "/" <> <<year::bytes-size(4)>>}) do
    get_calls_query_for(phone_number, month, year)
    |> Repo.all()
    |> group_as_call()
  end

  defp get_calls_query_for(phone_number, month, year) do
    {year, _} = Integer.parse(year)
    {month, _} = Integer.parse(month)

    subselect = from c in CallRecord,
    where: c.source == ^phone_number
    and fragment("date_part('year', ?)", c.timestamp) == ^year
    and (fragment("date_part('month', ?)", c.timestamp) == ^month or 
         fragment("date_part('month', ?)", c.timestamp) == ^(month - 1)),
    select: c.call_id

    call_records_of_reference_query = from call_record in CallRecord, 
    inner_join: sub in subquery(subselect),
    on: sub.call_id == call_record.call_id,
    select: call_record

    call_records_of_reference_query
  end

  defp group_as_call(these_call_records) do
    these_call_records
    |> Enum.group_by(fn call_record -> call_record.call_id end)
  end
  
  defp insert_in_parallel(grouped_calls) do
    grouped_calls
    |> Enum.map(fn {_not_used, call} -> Task.async(fn -> insert_data_of(call) end) end)
    |> Enum.map(&Task.await/1)
  end

  defp insert_data_of(call) do
    [first_call_record | [second_call_record]] = call

    Multi.new()
    |> Multi.run(:start_call, fn _ -> insert(first_call_record) end)
    |> Multi.run(:end_call, fn _ -> insert(second_call_record) end)
    |> Repo.transaction()
  end

  defp insert(call_record) do
    %CallRecord{}
    |> CallRecord.changeset(call_record) 
    |> Repo.insert()
  end

end