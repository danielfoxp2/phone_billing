defmodule BillingProcessor.CallRecordValidator do
  def validate(call_record) do
    call_record
    |> validate(:id)
    |> validate(:type)
    |> validate(:timestamp)
    |> validate(:call_id)
    |> validate(:source)
    |> validate(:destination)
  end

  defp validate(%{"type" => type} = call_record, :source) when type == "end", do: call_record
  defp validate(%{"type" => type} = call_record, :source) when type == "start" do
    call_record
    |> Map.get(:source)
    |> validate(call_record, :source)
  end

  defp validate(call_record, field) do
    call_record
    |> Map.get(field)
    |> validate(call_record, field)
  end

  defp validate("", in_call_record, field), do: mount_error_for(field, in_call_record)
  defp validate(nil, in_call_record, field),  do: mount_error_for(field, in_call_record)
  defp validate(_field_value, call_record, :id), do: call_record

  defp mount_error_for(field, in_call_record) do
    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", ["call record don't have #{field}"] ++ errors)
  end
end