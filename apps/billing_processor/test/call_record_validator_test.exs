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

    test "should invalidate when it does not contains the timestamp" do
      call_record_without_timestamp = %{}
      call_record_with_empty_timestamp = %{"timestamp" => ""}
      call_record_with_nil_timestamp = %{"timestamp" => nil}
      expected_message_error = "call record don't have timestamp"

      call_record_without_timestamp = CallRecordValidator.validate(call_record_without_timestamp)
      call_record_with_empty_timestamp = CallRecordValidator.validate(call_record_with_empty_timestamp)
      call_record_with_nil_timestamp = CallRecordValidator.validate(call_record_with_nil_timestamp)

      assert Enum.member?(call_record_without_timestamp["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_timestamp["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_timestamp["errors"], expected_message_error)
    end

    test "should invalidate when it does not contains the call id" do
      call_record_without_call_id = %{}
      call_record_with_empty_call_id = %{"call_id" => ""}
      call_record_with_nil_call_id = %{"call_id" => nil}
      expected_message_error = "call record don't have call_id"

      call_record_without_call_id = CallRecordValidator.validate(call_record_without_call_id)
      call_record_with_empty_call_id = CallRecordValidator.validate(call_record_with_empty_call_id)
      call_record_with_nil_call_id = CallRecordValidator.validate(call_record_with_nil_call_id)

      assert Enum.member?(call_record_without_call_id["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_call_id["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_call_id["errors"], expected_message_error)
    end 

    test "should invalidate when it does not contains the source in start record" do
      call_record_without_source = %{"type" => "start"}
      call_record_with_empty_source = %{"type" => "start", "source" => ""}
      call_record_with_nil_source = %{"type" => "start", "source" => nil}
      expected_message_error = "call record don't have source"

      call_record_without_source = CallRecordValidator.validate(call_record_without_source)
      call_record_with_empty_source = CallRecordValidator.validate(call_record_with_empty_source)
      call_record_with_nil_source = CallRecordValidator.validate(call_record_with_nil_source)

      assert Enum.member?(call_record_without_source["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_source["errors"], expected_message_error)
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

    test "should invalidate when it does not contains the destination in start record" do
      call_record_without_destination = %{"type" => "start"}
      call_record_with_empty_destination = %{"type" => "start", "destination" => ""}
      call_record_with_nil_destination = %{"type" => "start", "destination" => nil}
      expected_message_error = "call record don't have destination"

      call_record_without_destination = CallRecordValidator.validate(call_record_without_destination)
      call_record_with_empty_destination = CallRecordValidator.validate(call_record_with_empty_destination)
      call_record_with_nil_destination = CallRecordValidator.validate(call_record_with_nil_destination)

      assert Enum.member?(call_record_without_destination["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_destination["errors"], expected_message_error)
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

    test "should be a valid start call record when all fields are set" do
      expected_start_call_record = %{
        "id" => 1,
        "type" => "start",
        "timestamp" => "1970-01-01 00:00:01",
        "call_id" => 123,
        "source" => 62984680648,
        "destination" => 62111222333
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
        "call_id" => 123
      }

      call_record_after_validation = CallRecordValidator.validate(expected_end_call_record)

      assert call_record_after_validation["errors"] == nil
      assert call_record_after_validation == expected_end_call_record
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

  end
end