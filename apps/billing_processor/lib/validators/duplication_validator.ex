defmodule BillingProcessor.DuplicationValidator do
  alias BillingProcessor.Error

  @moduledoc false
  
  def add_errors_for_duplicated(call_records_being_inserted) do   
    call_records_being_inserted
    |> add_errors_for_duplicated("id")
    |> add_errors_for_duplicated("call_id")
  end

  def add_errors_for_duplicated_in_database({found_duplicated_in_database, call_records_being_inserted}) do   
    call_records_being_inserted
    |> add_errors_for_duplicated("id", found_duplicated_in_database)
    |> add_errors_for_duplicated("call_id", found_duplicated_in_database)
  end

  defp add_errors_for_duplicated(in_call_records_being_inserted, for_this_field) do
    Enum.map(in_call_records_being_inserted, fn call_record -> 
      Task.async(fn -> mount_error(for_this_field, call_record, in_call_records_being_inserted) end)
    end)
    |> Enum.map(&Task.await/1)
  end

  defp add_errors_for_duplicated(call_records_being_inserted, field, having_this_duplicated_registers_in_database) do
    Enum.map(call_records_being_inserted, fn call_record -> 
      Task.async(fn -> build_error(call_record, field, having_this_duplicated_registers_in_database) end)
    end)
    |> Enum.map(&Task.await/1)
  end

  defp mount_error(for_this_field, call_record, in_call_records_being_inserted) do
    count_how_much_duplicated(for_this_field, call_record, in_call_records_being_inserted)
    |> mount_error_if_needed_for(call_record, for_this_field)
  end

  defp build_error(call_record, field, having_this_duplicated_registers_in_database) do
    having_this_duplicated_registers_in_database
    |> Keyword.get_values(String.to_atom(field))
    |> has?(field, call_record)
    |> mount_error_if_needed_for(call_record, field)
  end

  defp count_how_much_duplicated(field, call_record, in_call_records_being_inserted) do
    Enum.count(in_call_records_being_inserted, fn call_record_to_be_inserted -> 
      equals?(call_record[field], call_record_to_be_inserted[field]) 
    end)
  end

  defp equals?("", _call_record_to_be_inserted), do: false
  defp equals?(nil, _call_record_to_be_inserted), do: false
  defp equals?(call_record_id, call_record_to_be_inserted), do: call_record_id == call_record_to_be_inserted

  defp has?(database_ids, field, call_record), do: call_record[field] in database_ids

  defp mount_error_if_needed_for(false, in_call_record, _field), do: in_call_record
  defp mount_error_if_needed_for(0, in_call_record, _field), do: in_call_record
  defp mount_error_if_needed_for(1, in_call_record, _field), do: in_call_record
  defp mount_error_if_needed_for(2, in_call_record, "call_id"), do: in_call_record
  defp mount_error_if_needed_for(true, in_call_record, "id" = field), do: Error.build(in_call_record, {:duplicated_in_database, field}, true)
  defp mount_error_if_needed_for(_, in_call_record, "id" = field), do: Error.build(in_call_record, {:duplicated_in_list_being_inserted, field}, true)
  defp mount_error_if_needed_for(true, in_call_record, "call_id" = field), do: Error.build(in_call_record, {:duplicated_in_database, field}, true)
  defp mount_error_if_needed_for(_, in_call_record, "call_id" = field), do: Error.build(in_call_record, {:duplicated_in_list_being_inserted, field}, true)
end