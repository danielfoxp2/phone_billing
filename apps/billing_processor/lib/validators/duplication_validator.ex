defmodule BillingProcessor.DuplicationValidator do
  alias BillingProcessor.Error

  def check_duplicates_in(duplicated_persisted_call_records, call_records_being_inserted) do
    call_records_ids_from_database = Keyword.get_values(duplicated_persisted_call_records, :id)

    add_errors_for_call_records_ids_duplicated_in(call_records_being_inserted)
    |> add_errors_of_duplicated_call_records_in(call_records_ids_from_database)
  end

  defp add_errors_for_call_records_ids_duplicated_in(call_records_being_inserted) do
    Enum.map(call_records_being_inserted, fn call_record -> 
        Enum.count(call_records_being_inserted, fn call_record_to_be_inserted -> 
          call_record["id"] == call_record_to_be_inserted["id"] 
        end)
        |> mount_error_if_needed_for(call_record, "id")
    end)
  end

  defp add_errors_of_duplicated_call_records_in(call_records_being_inserted, duplicated_database_ids) do
    Enum.map(call_records_being_inserted, fn call_record -> 
      duplicated_database_ids
      |> has?(call_record)
      |> mount_error_if_needed_for(call_record, "id")
    end)
  end

  defp has?(database_ids, call_record) do
    call_record["id"] in database_ids
  end

  defp mount_error_if_needed_for(false, call_record, _field), do: call_record
  defp mount_error_if_needed_for(true, in_call_record, field), do: Error.build(in_call_record, {:duplicated_in_database, field}, true)

  defp mount_error_if_needed_for(1, call_record, _field), do: call_record
  defp mount_error_if_needed_for(_, in_call_record, field), do: Error.build(in_call_record, {:duplicated_in_list_being_inserted, field}, true)
end