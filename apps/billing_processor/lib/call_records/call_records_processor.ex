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
    map_a = all_call_records
    |> Enum.reduce(%{}, fn (call_record, acumulator) -> 
      partial_quantity =  Map.get(acumulator, :received_records_quantity, 0) + 1
      acumulator = Map.put(acumulator, :received_records_quantity, partial_quantity)

      partial_quantity = Map.get(acumulator, :inconsistent_records_quantity, 0) + bla(call_record)
      acumulator = Map.put(acumulator, :inconsistent_records_quantity, partial_quantity)

      records_with_error = Map.get(acumulator, :failed_records_on_validation, []) ++ blabla(call_record)
      Map.put(acumulator, :failed_records_on_validation, records_with_error)
    end)

    map_b = call_records_inserted
    |> Enum.reduce(%{}, fn (call_record, acumulator) -> 
      partial_quantity = Map.get(acumulator, :consistent_records_quantity, 0) + blaah(call_record)
      acumulator = Map.put(acumulator, :consistent_records_quantity, partial_quantity)

      partial_quantity = Map.get(acumulator, :database_inconsistent_records_quantity, 0) + bla(call_record)
      acumulator = Map.put(acumulator, :database_inconsistent_records_quantity, partial_quantity)

      records_with_error_on_database = Map.get(acumulator, :failed_records_on_insert, []) ++ blabla(call_record)
      Map.put(acumulator, :failed_records_on_insert, records_with_error_on_database)
    end)
    
    Map.merge(map_a, map_b)
  end

  defp blaah({:ok, _not_used}), do: 1
  defp blaah(_is_inconsistent), do: 0

  defp bla({:error, _not_used}), do: 1
  defp bla(%{"errors" => errors}), do: 1
  defp bla(_call_record_without_errors), do: 0

  defp blabla({:error, call_record}), do: [call_record]
  defp blabla(%{"errors" => errors} = call_record), do: [call_record]
  defp blabla(_call_record_without_errors), do: []
  
end