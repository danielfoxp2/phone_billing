defmodule BillingProcessor.DuplicationValidator do
  alias BillingProcessor.Error

  def check_duplicates_in(duplicated_persisted_call_records, call_records_being_inserted) do
    database_ids = Keyword.get_values(duplicated_persisted_call_records, :id)

    Enum.map call_records_being_inserted, fn call_record -> 
      database_ids
      |> has?(call_record)
      |> mount_error_if_needed_for(call_record, "id")
    end
  end

  defp has?(database_ids, call_record) do
    call_record["id"] in database_ids
  end

  def mount_error_if_needed_for(false, call_record, _field), do: call_record
  def mount_error_if_needed_for(true, in_call_record, field), do: Error.build(in_call_record, field, true)

end