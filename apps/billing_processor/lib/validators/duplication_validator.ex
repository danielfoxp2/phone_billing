defmodule BillingProcessor.DuplicationValidator do
  alias BillingProcessor.Error

  def check_duplicates_in(duplicated_persisted_call_records, call_records_being_inserted) do
    call_records_ids_from_database = Keyword.get_values(duplicated_persisted_call_records, :id)

    add_errors_for_call_records_ids_duplicated_in(call_records_being_inserted)
    |> add_errors_of_duplicated_call_records_in(call_records_ids_from_database)
  end

  defp add_errors_for_call_records_ids_duplicated_in(call_records_being_inserted) do
    Enum.map(call_records_being_inserted, fn call_record -> 
      count_how_much_duplicated_ids_of_this(call_record, call_records_being_inserted)
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

  defp count_how_much_duplicated_ids_of_this(call_record, in_call_records_being_inserted) do
    Enum.count(in_call_records_being_inserted, fn call_record_to_be_inserted -> 
      equals?(call_record["id"], call_record_to_be_inserted["id"]) 
    end)
  end

  defp equals?("", _call_record_to_be_inserted), do: false
  defp equals?(nil, _call_record_to_be_inserted), do: false
  defp equals?(call_record_id, call_record_to_be_inserted), do: call_record_id == call_record_to_be_inserted

  defp has?(database_ids, call_record), do: call_record["id"] in database_ids

  defp mount_error_if_needed_for(false, in_call_record, _field), do: in_call_record
  defp mount_error_if_needed_for(0, in_call_record, _field), do: in_call_record
  defp mount_error_if_needed_for(1, in_call_record, _field), do: in_call_record
  defp mount_error_if_needed_for(true, in_call_record, field), do: Error.build(in_call_record, {:duplicated_in_database, field}, true)
  defp mount_error_if_needed_for(_, in_call_record, field), do: Error.build(in_call_record, {:duplicated_in_list_being_inserted, field}, true)
end