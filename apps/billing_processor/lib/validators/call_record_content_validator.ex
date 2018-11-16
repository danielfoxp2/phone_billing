defmodule BillingProcessor.CallRecordContentValidator do
  alias BillingProcessor.TimestampValidator
  alias BillingProcessor.Error

  def validate(call_records) do
    call_records
    |> process_validation_in_parallel
  end

  defp process_validation_in_parallel(of_these_call_records) do
    Enum.map(of_these_call_records, fn call_record -> Task.async(fn -> process(call_record) end) end)
    |> Enum.map(&Task.await/1)
  end

  defp process(call_record) do
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
    is_invalid = true
    Error.build(in_call_record, "type", is_invalid)
  end

  defp validate(%{"timestamp" => timestamp} = call_record, "timestamp") when not is_nil(timestamp) do
    when_it_is_invalid = TimestampValidator.check_consistence_of(timestamp)
    Error.build(call_record, "timestamp", when_it_is_invalid)
  end

  defp validate(%{"call_id" => call_id} = in_call_record, "call_id") when not is_nil(call_id) do
    only_integer = ~r/^[0-9]+$/
    validate_number_in(in_call_record, "call_id", call_id, only_integer)
  end

  defp validate(%{"source" => source} = call_record, "source") when not is_nil(source) do
    validate_number_in(call_record, "source", source, only_integer_with_ten_or_eleven_digits_regex())
  end

  defp validate(%{"destination" => destination} = call_record, "destination") when not is_nil(destination) do
    validate_number_in(call_record, "destination", destination, only_integer_with_ten_or_eleven_digits_regex())
  end

  defp validate(call_record, field) do
    call_record
    |> Map.get(field)
    |> validate(call_record, field)
  end

  defp validate_number_in(in_call_record, field, value, regex) do
    when_it_is_invalid = Regex.match?(regex, "#{value}") == false
    Error.build(in_call_record, field, when_it_is_invalid)
  end

  defp only_integer_with_ten_or_eleven_digits_regex(), do: ~r/^\d{10,11}+$/
  
  defp validate(field_value, in_call_record, field) when is_nil(field_value) or field_value == "" do
    is_invalid = true
    Error.build(in_call_record, {:structure, field}, is_invalid)
  end
  defp validate(_field_value, call_record, _field), do: call_record
   
end