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
      call_record_with_empty_type = %{"type" => ""}
      call_record_with_nil_type = %{"type" => nil}
      expected_message_error = "call record don't have type"

      call_record_without_type = CallRecordValidator.validate(call_record_without_type)
      call_record_with_empty_type = CallRecordValidator.validate(call_record_with_empty_type)
      call_record_with_nil_type = CallRecordValidator.validate(call_record_with_nil_type)

      assert Enum.member?(call_record_without_type["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_type["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_type["errors"], expected_message_error)
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

    test "should invalidate when it does not contains the source" do
      call_record_without_source = %{}
      call_record_with_empty_source = %{"source" => ""}
      call_record_with_nil_source = %{"source" => nil}
      expected_message_error = "call record don't have source"

      call_record_without_source = CallRecordValidator.validate(call_record_without_source)
      call_record_with_empty_source = CallRecordValidator.validate(call_record_with_empty_source)
      call_record_with_nil_source = CallRecordValidator.validate(call_record_with_nil_source)

      assert Enum.member?(call_record_without_source["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_source["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_source["errors"], expected_message_error)
    end

    test "should invalidate when it does not contains the destination" do
      call_record_without_destination = %{}
      call_record_with_empty_destination = %{"destination" => ""}
      call_record_with_nil_destination = %{"destination" => nil}
      expected_message_error = "call record don't have destination"

      call_record_without_destination = CallRecordValidator.validate(call_record_without_destination)
      call_record_with_empty_destination = CallRecordValidator.validate(call_record_with_empty_destination)
      call_record_with_nil_destination = CallRecordValidator.validate(call_record_with_nil_destination)

      assert Enum.member?(call_record_without_destination["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_destination["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_destination["errors"], expected_message_error)
    end

  end
end