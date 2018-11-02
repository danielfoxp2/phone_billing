defmodule BillingProcessor.CallRecordValidator do
  def validate(call_record) do
    call_record
    |> validate("id")
    |> validate("type")
    |> validate("timestamp")
    |> validate("call_id")
    |> validate("source")
    |> validate("destination")
  end

  defp validate(%{"type" => type} = call_record, "source") when type == "end", do: call_record
  defp validate(%{"type" => type} = call_record, "destination") when type == "end", do: call_record
  defp validate(%{"type" => type} = call_record, "type") when type not in ["start", "end"] do
    error_message = "Call record has a wrong type: '#{type}'. Only 'start' and 'end' types are allowed."

    errors = Map.get(call_record, "errors", [])
    Map.put(call_record, "errors", [error_message] ++ errors)
  end

  defp validate(%{"timestamp" => timestamp} = call_record, "timestamp") when not is_nil(timestamp) do
    NaiveDateTime.from_iso8601(timestamp)
    |> validate_timestamp_of(call_record)
  end

  defp validate(%{"call_id" => call_id} = call_record, "call_id") when not is_nil(call_id) do
    only_integer = ~r/^[0-9]+$/

    Regex.match?(only_integer, call_id)
    |> validate_call_id_of(call_record) 
  end

  defp validate(%{"source" => source} = call_record, "source") when not is_nil(source) do
    only_integer_with_ten_or_eleven_digits = ~r/^\d{10,11}+$/
    
    Regex.match?(only_integer_with_ten_or_eleven_digits, source)
    |> validate_of(call_record, "source")
  end

  defp validate(%{"destination" => destination} = call_record, "destination") when not is_nil(destination) do
    only_integer_with_ten_or_eleven_digits = ~r/^\d{10,11}+$/
    
    Regex.match?(only_integer_with_ten_or_eleven_digits, destination)
    |> validate_of(call_record, "destination")
  end

  defp validate(call_record, field) do
    call_record
    |> Map.get(field)
    |> validate(call_record, field)
  end

  defp validate("", in_call_record, field), do: mount_error_for(field, in_call_record)
  defp validate(nil, in_call_record, field), do: mount_error_for(field, in_call_record)
  defp validate(_field_value, call_record, _field), do: call_record

  defp mount_error_for(field, in_call_record) do
    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", ["call record don't have #{field}"] ++ errors)
  end

  defp validate_timestamp_of({:ok, _}, in_call_record), do: in_call_record
  defp validate_timestamp_of(_invalid_timestamp, in_call_record) do
    error_message = "Call record has a wrong timestamp: '#{in_call_record["timestamp"]}'. The timestamp must have this format: YYYY-MM-DDThh:mm:ssZ"

    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", [error_message] ++ errors)
  end

  defp validate_call_id_of(true, in_call_record), do: in_call_record
  defp validate_call_id_of(false, in_call_record) do
    error_message = "Call record has a wrong call id: '#{in_call_record["call_id"]}'. The call id must be integer"

    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", [error_message] ++ errors)
  end

  defp validate_of(true, in_call_record, _field), do: in_call_record
  defp validate_of(false, in_call_record, field) do
    errors = Map.get(in_call_record, "errors", [])
    Map.put(in_call_record, "errors", [error_message_for_phone_number_of(field, in_call_record[field])] ++ errors)
  end

  defp error_message_for_phone_number_of(field, value) do
    """
    Call record has a wrong #{field}: '#{value}'. 
    The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
    The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
    """
  end
    
end