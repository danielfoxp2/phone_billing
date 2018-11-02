defmodule BillingProcessor.CallRecordValidator do
  alias BillingProcessor.ErrorMessage
  alias BillingProcessor.TimestampValidator
  alias BillingProcessor.Error

  def validate(call_record) do
    call_record
    |> validate("id")
    |> validate("type")
    |> validate("timestamp")
    |> validate("call_id")
    |> validate("source")
    |> validate("destination")
  end

  defp validate(%{"type" => value} = call_record, "source") when value == "end", do: call_record
  defp validate(%{"type" => value} = call_record, "destination") when value == "end", do: call_record
  defp validate(%{"type" => value} = in_call_record, "type") when value not in ["start", "end"] do
    validate_of(false, in_call_record, "type")
  end

  defp validate(%{"timestamp" => timestamp} = call_record, "timestamp") when not is_nil(timestamp) do
    when_it_is_invalid = TimestampValidator.check_consistence_of(timestamp)
    Error.build(call_record, "timestamp", when_it_is_invalid)
  end

  defp validate(%{"call_id" => call_id} = call_record, "call_id") when not is_nil(call_id) do
    only_integer = ~r/^[0-9]+$/

    Regex.match?(only_integer, call_id)
    |> validate_of(call_record, "call_id") 
  end

  defp validate(%{"source" => source} = call_record, "source") 
  when not is_nil(source), do: validate_phone_number_in(call_record, "source", source)

  defp validate(%{"destination" => destination} = call_record, "destination") 
  when not is_nil(destination), do: validate_phone_number_in(call_record, "destination", destination)

  defp validate(call_record, field) do
    call_record
    |> Map.get(field)
    |> validate(call_record, field)
  end

  defp include(error_message, in_call_record) do
    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", [error_message] ++ errors)
  end

  defp validate_phone_number_in(call_record, field, value) do
    only_integer_with_ten_or_eleven_digits = ~r/^\d{10,11}+$/
    
    Regex.match?(only_integer_with_ten_or_eleven_digits, value)
    |> validate_of(call_record, field)
  end

  defp validate("", in_call_record, field), do: ErrorMessage.for_wrong(field) |> include(in_call_record)
  defp validate(nil, in_call_record, field), do: ErrorMessage.for_wrong(field) |> include(in_call_record)
  defp validate(_field_value, call_record, _field), do: call_record

  defp validate_of({:ok, _}, in_call_record, _field), do: in_call_record
  defp validate_of({:error, _}, in_call_record, field), do: validate_of(false, in_call_record, field)
  defp validate_of(true, in_call_record, _field), do: in_call_record
  defp validate_of(false, in_call_record, field) do
    ErrorMessage.for_wrong(field, in_call_record[field])
    |> include(in_call_record)
  end
    
end