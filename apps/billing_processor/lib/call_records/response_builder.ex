defmodule BillingProcessor.ResponseBuilder do

  def mount_processing_result({call_records_inserted, all_call_records}) do
    response_of_processing_validation = mount_parallel_response_of_processing_validation_of(all_call_records)
    response_of_database_insertion = mount_parallel_response_of_database_insertion_of(call_records_inserted)

    Task.await(response_of_processing_validation)
    |> Map.merge(Task.await(response_of_database_insertion))
  end

  defp mount_parallel_response_of_processing_validation_of(all_call_records) do
    Task.async(fn -> mount_response_of_processing_validation_of(all_call_records) end)
  end

  defp mount_parallel_response_of_database_insertion_of(call_records_inserted) do
    Task.async(fn -> mount_response_of_database_insertion_of(call_records_inserted) end)
  end

  defp mount_response_of_processing_validation_of(call_records) do
    Enum.reduce(call_records, %{}, fn (with_this_call_record, response_of_processing) -> 
      response_of_processing
      |> increment(:received_records_quantity, :all_call_records)
      |> increment(:inconsistent_records_quantity, with_this_call_record)
      |> aggregate(:failed_records_on_validation, with_this_call_record)
    end)
  end

  defp mount_response_of_database_insertion_of([]) do
    %{
      consistent_records_quantity: 0,
      database_inconsistent_records_quantity: 0,
      failed_records_on_insert: []
    }
  end

  defp mount_response_of_database_insertion_of(call_records_inserted) do
    Enum.reduce(call_records_inserted, %{}, fn (with_this_call_record, response_of_processing) -> 
      response_of_processing
      |> increment(:consistent_records_quantity, {:inserted_in_database, with_this_call_record})
      |> increment(:database_inconsistent_records_quantity, with_this_call_record)
      |> aggregate(:failed_records_on_insert, with_this_call_record)
    end)
  end

  defp increment(response_of_processing, field, call_record_or_type_of_return) do
    partial_quantity =  Map.get(response_of_processing, field, 0) + get({:increment, call_record_or_type_of_return})
    Map.put(response_of_processing, field, partial_quantity)
  end

  defp aggregate(response_of_processing, field, call_record) do
    records_with_error_on_database = Map.get(response_of_processing, field, []) ++ get({:aggregate, call_record})
    Map.put(response_of_processing, field, records_with_error_on_database)
  end

  defp get({:increment, :all_call_records}), do: 1
  defp get({:increment, {:inserted_in_database, {:ok, _not_used}}}), do: 2
  defp get({:increment, %{"errors" => _errors}}), do: 1
  defp get({:increment, {:error, _not_used}}), do: 2
  defp get({:increment, _call_record_without_errors}), do: 0
  defp get({:aggregate, %{"errors" => _errors} = call_record}), do: [call_record]
  defp get({:aggregate, {:error, call}}), do: get_call_records_from(call)
  defp get({:aggregate, _call_record_without_errors}), do: []

  defp get_call_records_from(%{start_call: start_call, end_call: end_call}) do
    [get_map_from(start_call), get_map_from(end_call)]
  end

  defp get_map_from(call_record) do
    call_record 
    |> Map.from_struct 
    |> Map.drop([:__meta__, :inserted_at, :updated_at])
  end
end