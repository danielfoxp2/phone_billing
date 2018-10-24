defmodule BillingProcessor.CallRecordValidator do
  def validate(call_record) do
    validate_id(call_record)
    |> validate_type()
  end

  defp validate_id(call_record) do
    get_field(call_record, :id)
    |> validate(call_record, :id)
  end

  defp validate_type(call_record) do
    get_field(call_record, :type)
    |> validate(call_record, :type)
  end

  defp get_field(call_record, field), do: Map.get(call_record, field)

  defp validate("", in_call_record, field), do: mount_error_for(field, in_call_record)
  defp validate(nil, in_call_record, field),  do: mount_error_for(field, in_call_record)
  defp validate(_field_value, call_record, :id), do: call_record

  defp mount_error_for(field, in_call_record) do
    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", ["call record don't have #{field}"] ++ errors)
  end
end