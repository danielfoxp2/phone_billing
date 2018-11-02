defmodule BillingProcessor.CallRecordValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.CallRecordValidator

  describe "call record validation" do
    test "should invalidate when it does not contains the id" do
      call_record_without_id = %{}
      call_record_with_empty_id = %{"id" => ""}
      call_record_with_nil_id = %{"id" => nil}
      expected_message_error = "call record don't have id"

      call_record_without_id = CallRecordValidator.validate(call_record_without_id)
      call_record_with_empty_id = CallRecordValidator.validate(call_record_with_empty_id)
      call_record_with_nil_id = CallRecordValidator.validate(call_record_with_nil_id)

      assert Enum.member?(call_record_without_id["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_id["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_id["errors"], expected_message_error)
    end

    test "should invalidate when it does not contains the type" do
      call_record_without_type = %{}
     
      expected_message_error = "call record don't have type"

      call_record_without_type = CallRecordValidator.validate(call_record_without_type)
     
      assert Enum.member?(call_record_without_type["errors"], expected_message_error)
    end

    test "should invalidate when type of record is diferent of 'start' or 'end'" do
      call_record_with_empty_type = %{"type" => ""}
      call_record_with_nil_type = %{"type" => nil}
      call_record_with_not_allowed_type = %{"type" => "new_type"}

      expected_message_error_for_nil_and_empty_type = "Call record has a wrong type: ''. Only 'start' and 'end' types are allowed."
      expected_message_error_for_not_allowed_type = "Call record has a wrong type: 'new_type'. Only 'start' and 'end' types are allowed."

      call_record_with_empty_type = CallRecordValidator.validate(call_record_with_empty_type)
      call_record_with_nil_type = CallRecordValidator.validate(call_record_with_nil_type)
      call_record_after_validation = CallRecordValidator.validate(call_record_with_not_allowed_type)

      assert Enum.member?(call_record_with_empty_type["errors"], expected_message_error_for_nil_and_empty_type)
      assert Enum.member?(call_record_with_nil_type["errors"], expected_message_error_for_nil_and_empty_type)
      assert Enum.member?(call_record_after_validation["errors"], expected_message_error_for_not_allowed_type)
    end

    test "should invalidate when it does not contains the timestamp" do
      call_record_without_timestamp = %{}
      call_record_with_nil_timestamp = %{"timestamp" => nil}

      expected_message_error = "call record don't have timestamp"

      call_record_without_timestamp = CallRecordValidator.validate(call_record_without_timestamp)
      call_record_with_nil_timestamp = CallRecordValidator.validate(call_record_with_nil_timestamp)
     
      assert Enum.member?(call_record_without_timestamp["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_timestamp["errors"], expected_message_error)
    end

    test "should invalidate when timestamp has not YYYY-MM-DDThh:mm:ssZ format" do
      call_record_with_empty_timestamp = %{"timestamp" => ""}
      call_record_with_invalid_timestamp = %{"timestamp" => "44:23"}

      expected_message_error_for_empty_timestamp = "Call record has a wrong timestamp: ''. The timestamp must have this format: YYYY-MM-DDThh:mm:ssZ"
      expected_message_error_for_not_allowed_timestamp = "Call record has a wrong timestamp: '44:23'. The timestamp must have this format: YYYY-MM-DDThh:mm:ssZ"
      
      call_record_with_empty_timestamp = CallRecordValidator.validate(call_record_with_empty_timestamp)
      call_record_with_invalid_timestamp = CallRecordValidator.validate(call_record_with_invalid_timestamp)

      assert Enum.member?(call_record_with_empty_timestamp["errors"], expected_message_error_for_empty_timestamp)
      assert Enum.member?(call_record_with_invalid_timestamp["errors"], expected_message_error_for_not_allowed_timestamp)
    end

    test "should invalidate when it does not contains the call id" do
      call_record_without_call_id = %{}
      call_record_with_nil_call_id = %{"call_id" => nil}

      expected_message_error = "call record don't have call_id"
      
      call_record_without_call_id = CallRecordValidator.validate(call_record_without_call_id)
      call_record_with_nil_call_id = CallRecordValidator.validate(call_record_with_nil_call_id)
      
      assert Enum.member?(call_record_without_call_id["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_call_id["errors"], expected_message_error)
    end 

    test "should invalidate when call id is not a integer" do
      call_record_with_empty_call_id = %{"call_id" => ""}
      call_record_with_alfanumeric_call_id = %{"call_id" => "554gf"}
      call_record_with_float_call_id = %{"call_id" => "554.89"}

      expected_message_error_for_empty_call_id = "Call record has a wrong call id: ''. The call id must be integer"
      expected_message_error_for_alfanumeric_call_id = "Call record has a wrong call id: '554gf'. The call id must be integer"
      expected_message_error_for_float_call_id = "Call record has a wrong call id: '554.89'. The call id must be integer"

      call_record_with_empty_call_id = CallRecordValidator.validate(call_record_with_empty_call_id)
      call_record_with_alfanumeric_call_id = CallRecordValidator.validate(call_record_with_alfanumeric_call_id)
      call_record_with_float_call_id = CallRecordValidator.validate(call_record_with_float_call_id)

      assert Enum.member?(call_record_with_empty_call_id["errors"], expected_message_error_for_empty_call_id)
      assert Enum.member?(call_record_with_alfanumeric_call_id["errors"], expected_message_error_for_alfanumeric_call_id)
      assert Enum.member?(call_record_with_float_call_id["errors"], expected_message_error_for_float_call_id)
    end

    test "should invalidate when it does not contains the source in start record" do
      call_record_without_source = %{"type" => "start"}
      call_record_with_nil_source = %{"type" => "start", "source" => nil}
      expected_message_error = "call record don't have source"

      call_record_without_source = CallRecordValidator.validate(call_record_without_source)
      call_record_with_nil_source = CallRecordValidator.validate(call_record_with_nil_source)

      assert Enum.member?(call_record_without_source["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_source["errors"], expected_message_error)
    end

    test "should be a valid call record when not contains the source but it is a end type record" do
      call_record_without_source = %{"type" => "end"}
      call_record_with_empty_source = %{"type" => "end", "source" => ""}
      call_record_with_nil_source = %{"type" => "end", "source" => nil}
      expected_message_error = "call record don't have source"
      expected_result = false
    
      call_record_without_source = CallRecordValidator.validate(call_record_without_source)
      call_record_with_empty_source = CallRecordValidator.validate(call_record_with_empty_source)
      call_record_with_nil_source = CallRecordValidator.validate(call_record_with_nil_source)

      actual_result_without_source = Enum.member?(call_record_without_source["errors"], expected_message_error)
      actual_result_with_empty_source = Enum.member?(call_record_with_empty_source["errors"], expected_message_error)
      actual_result_with_nil_source = Enum.member?(call_record_with_nil_source["errors"], expected_message_error)

      assert actual_result_without_source == expected_result
      assert actual_result_with_empty_source == expected_result
      assert actual_result_with_nil_source == expected_result
    end

    test "should invalidate when source has not AAXXXXXXXX or AAXXXXXXXXX format" do
      empty_source = ""
      alfanumeric_source = "62432224x"
      source_with_invalid_lenght = "6243222"

      call_record_with_empty_source = %{"type" => "start", "source" => empty_source}
      call_record_with_alfanumeric_source = %{"type" => "start", "source" => alfanumeric_source}
      call_record_with_invalid_lenght_source = %{"type" => "start", "source" => source_with_invalid_lenght}

      call_record_with_empty_source = CallRecordValidator.validate(call_record_with_empty_source)
      call_record_with_alfanumeric_source = CallRecordValidator.validate(call_record_with_alfanumeric_source)
      call_record_with_invalid_lenght_source = CallRecordValidator.validate(call_record_with_invalid_lenght_source)

      assert Enum.member?(call_record_with_empty_source["errors"], expected_message_error_for(empty_source))
      assert Enum.member?(call_record_with_alfanumeric_source["errors"], expected_message_error_for(alfanumeric_source))
      assert Enum.member?(call_record_with_invalid_lenght_source["errors"], expected_message_error_for(source_with_invalid_lenght))
    end

    test "should invalidate when it does not contains the destination in start record" do
      call_record_without_destination = %{"type" => "start"}
      call_record_with_nil_destination = %{"type" => "start", "destination" => nil}
      expected_message_error = "call record don't have destination"

      call_record_without_destination = CallRecordValidator.validate(call_record_without_destination)
      call_record_with_nil_destination = CallRecordValidator.validate(call_record_with_nil_destination)

      assert Enum.member?(call_record_without_destination["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_destination["errors"], expected_message_error)
    end

    test "should be a valid call record when not contains the destination but it is a end type record" do
      call_record_without_destination = %{"type" => "end"}
      call_record_with_empty_destination = %{"type" => "end", "destination" => ""}
      call_record_with_nil_destination = %{"type" => "end", "destination" => nil}
      expected_message_error = "call record don't have destination"
      expected_result = false
    
      call_record_without_destination = CallRecordValidator.validate(call_record_without_destination)
      call_record_with_empty_destination = CallRecordValidator.validate(call_record_with_empty_destination)
      call_record_with_nil_destination = CallRecordValidator.validate(call_record_with_nil_destination)

      actual_result_without_destination = Enum.member?(call_record_without_destination["errors"], expected_message_error)
      actual_result_with_empty_destination = Enum.member?(call_record_with_empty_destination["errors"], expected_message_error)
      actual_result_with_nil_destination = Enum.member?(call_record_with_nil_destination["errors"], expected_message_error)

      assert actual_result_without_destination == expected_result
      assert actual_result_with_empty_destination == expected_result
      assert actual_result_with_nil_destination == expected_result
    end

    test "should invalidate when destination has not AAXXXXXXXX or AAXXXXXXXXX format" do
      empty_destination = ""
      alfanumeric_destination = "6243sh2445"
      destination_with_invalid_lenght = "43388"

      call_record_with_empty_destination = %{"type" => "start", "destination" => empty_destination}
      call_record_with_alfanumeric_destination = %{"type" => "start", "destination" => alfanumeric_destination}
      call_record_with_invalid_lenght_destination = %{"type" => "start", "destination" => destination_with_invalid_lenght}

      call_record_with_empty_destination = CallRecordValidator.validate(call_record_with_empty_destination)
      call_record_with_alfanumeric_destination = CallRecordValidator.validate(call_record_with_alfanumeric_destination)
      call_record_with_invalid_lenght_destination = CallRecordValidator.validate(call_record_with_invalid_lenght_destination)

      assert Enum.member?(call_record_with_empty_destination["errors"], expected_destination_message_error_for(empty_destination))
      assert Enum.member?(call_record_with_alfanumeric_destination["errors"], expected_destination_message_error_for(alfanumeric_destination))
      assert Enum.member?(call_record_with_invalid_lenght_destination["errors"], expected_destination_message_error_for(destination_with_invalid_lenght))
    end

    test "should be a valid start call record when all fields are set" do
      expected_start_call_record = %{
        "id" => 1,
        "type" => "start",
        "timestamp" => "1970-01-01 00:00:01",
        "call_id" => "123",
        "source" => "62984680648",
        "destination" => "62111222333"
      }

      call_record_after_validation = CallRecordValidator.validate(expected_start_call_record)

      assert call_record_after_validation["errors"] == nil
      assert call_record_after_validation == expected_start_call_record
    end

    test "should be a valid end call record when all fields are set" do
      expected_end_call_record = %{
        "id" => 1,
        "type" => "end",
        "timestamp" => "1970-01-01 00:00:01",
        "call_id" => "123"
      }

      call_record_after_validation = CallRecordValidator.validate(expected_end_call_record)

      assert call_record_after_validation["errors"] == nil
      assert call_record_after_validation == expected_end_call_record
    end

    defp expected_message_error_for(field_value) do
      """
      Call record has a wrong source: '#{field_value}'. 
      The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
      The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
      """
    end

    defp expected_destination_message_error_for(field_value) do
      """
      Call record has a wrong destination: '#{field_value}'. 
      The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
      The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
      """
    end

  end
end