defmodule BillingProcessor.CallRecordsProcessor do

  def get_only_valid(call_records) do
    grouped_valid_call = group_only_valid(call_records)
    {grouped_valid_call, call_records}
  end
  
  # def execute({call_records_inserted, all_call_records}) do
  #   %{
  #     received_records_quantity: Enum.count(all_call_records),
  #     consistent_records_quantity: Enum.count(call_records_inserted, &where_everything_is_ok/1),
  #     inconsistent_records_quantity: Enum.count(all_call_records, &which_contains_errors/1),
  #     database_inconsistent_records_quantity: Enum.count(call_records_inserted, &which_contains_errors/1),
  #     failed_records_on_validation: Enum.filter(all_call_records, &which_contains_errors/1),
  #     failed_records_on_insert: Enum.filter(call_records_inserted, &which_contains_errors/1)
  #   }
  # end

  defp group_only_valid(call_records) do
    Enum.filter(call_records, fn call_record -> call_record["errors"] == nil end)
    |> Enum.group_by(fn call_record -> call_record["call_id"] end)
  end

  # defp where_everything_is_ok({status, _not_used}), do: status == :ok
  
  # defp which_contains_errors({status, _in_call_record}), do: status == :error
  # defp which_contains_errors(in_call_record), do: in_call_record["errors"] != nil


  def execute({call_records_inserted, all_call_records}) do
    first_step(all_call_records)
    |> Map.merge(second_step(call_records_inserted))
  end

  defp first_step(call_records) do
    Enum.reduce(call_records, %{}, fn (call_record, acumulator) -> 
      acumulator
      |> increment(:received_records_quantity, :return_one)
      |> increment(:inconsistent_records_quantity, call_record)
      |> aggregate(:failed_records_on_validation, call_record)
    end)
  end

  defp second_step(call_records_inserted) do
    Enum.reduce(call_records_inserted, %{}, fn (call_record, acumulator) -> 
      acumulator
      |> increment(:consistent_records_quantity, {call_record, :co})
      |> increment(:database_inconsistent_records_quantity, call_record)
      |> aggregate(:failed_records_on_insert, call_record)
    end)
  end

  defp increment(acumulator, field, call_record_or_type_of_return) do
    partial_quantity =  Map.get(acumulator, field, 0) + bla(call_record_or_type_of_return)
    Map.put(acumulator, field, partial_quantity)
  end

  defp aggregate(acumulator, field, call_record) do
    records_with_error_on_database = Map.get(acumulator, field, []) ++ blabla(call_record)
    Map.put(acumulator, field, records_with_error_on_database)
  end

  defp bla({{:ok, _not_used}, :co}), do: 1
  defp bla(:return_one), do: 1
  defp bla({:error, _not_used}), do: 1
  defp bla(%{"errors" => errors}), do: 1
  defp bla(_call_record_without_errors), do: 0

  defp blabla({:error, call_record}), do: [call_record]
  defp blabla(%{"errors" => errors} = call_record), do: [call_record]
  defp blabla(_call_record_without_errors), do: []
  
end