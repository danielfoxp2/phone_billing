defmodule BillingProcessor.CallRecordValidator do
  def validate(call_record) do
    call_record
    |> validate_id()
    |> validate_type()
    |> validate_timestamp()
    |> validate_call_id()
    |> validate_source()
  end

  defp validate_id(call_record) do
    call_record
    |> get_field(:id)
    |> validate(call_record, :id)
  end

  defp validate_type(call_record) do
    call_record
    |> get_field(:type)
    |> validate(call_record, :type)
  end

  defp validate_timestamp(call_record) do
    call_record
    |> get_field(:timestamp)
    |> validate(call_record, :timestamp)
  end

  defp validate_call_id(call_record) do
    call_record
    |> get_field(:call_id)
    |> validate(call_record, :call_id)
  end

  defp validate_source(call_record) do
    call_record
    |> get_field(:source)
    |> validate(call_record, :source)
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