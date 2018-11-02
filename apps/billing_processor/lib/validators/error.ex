defmodule BillingProcessor.Error do
  alias BillingProcessor.ErrorMessage

  def build(in_call_record, field, when_it_is_invalid) do
    when_it_is_invalid
    |> mount_error(in_call_record, field)
  end

  defp mount_error(false, in_call_record, _field), do: in_call_record
  defp mount_error(true, in_call_record, field) do
    ErrorMessage.for_wrong(field, in_call_record[field])
    |> include(in_call_record)
  end

  defp include(error_message, in_call_record) do
    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", [error_message] ++ errors)
  end

end