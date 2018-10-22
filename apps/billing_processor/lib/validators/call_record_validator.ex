defmodule BillingProcessor.CallRecordValidator do
  def validate(call_record) do
    validate_id(call_record)
  end

  defp validate_id(call_record) do
    get_field(call_record, :id)
    |> validate(call_record, :id)
  end

  defp get_field(call_record, field) do
    Map.get(call_record, field)
  end

  defp validate("", call_record, :id) do
    errors = Map.get(call_record, :errors, [])
    Map.put(call_record, "errors", ["call record don't have an id"] ++ errors)
  end

  defp validate(nil, call_record, :id)  do
    errors = Map.get(call_record, :errors, [])
    Map.put(call_record, "errors", ["call record don't have an id"] ++ errors)
  end
  
  defp validate(_field_value, call_record, :id), do: call_record

end