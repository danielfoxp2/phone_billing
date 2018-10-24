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

  defp get_field(call_record, field) do
    Map.get(call_record, field)
  end

  defp validate("", call_record, field) do
    errors = Map.get(call_record, "errors", [])
    Map.put(call_record, "errors", ["call record don't have #{field}"] ++ errors)
  end

  defp validate(nil, call_record, field)  do
    errors = Map.get(call_record, "errors", [])
    Map.put(call_record, "errors", ["call record don't have #{field}"] ++ errors)
  end

  defp validate(_field_value, call_record, :id), do: call_record

end