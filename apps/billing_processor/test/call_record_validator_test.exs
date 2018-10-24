defmodule BillingProcessor.CallRecordValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.CallRecordValidator

  describe "call record validation" do
    test "should invalidate when it does not contains the id" do
      call_record_without_id = %{"type" => "sfa"}
      call_record_with_empty_id = %{"id" => "", "type" => "sfa"}
      call_record_with_nil_id = %{"id" => nil, "type" => "sfa"}
      expected_message_error = "call record don't have id"

      call_record_without_id_gotten = CallRecordValidator.validate(call_record_without_id)
      call_record_with_empty_id_gotten = CallRecordValidator.validate(call_record_with_empty_id)
      call_record_with_nil_id_gotten = CallRecordValidator.validate(call_record_with_nil_id)

      assert Enum.member?(call_record_without_id_gotten["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_id_gotten["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_id_gotten["errors"], expected_message_error)
    end

    test "should invalidate when it does not contains the type" do
      call_record_without_type = %{}
      call_record_with_empty_type = %{"type" => ""}
      call_record_with_nil_type = %{"type" => nil}
      expected_message_error = "call record don't have type"

      call_record_without_type_gotten = CallRecordValidator.validate(call_record_without_type)
      call_record_with_empty_type_gotten = CallRecordValidator.validate(call_record_with_empty_type)
      call_record_with_nil_type_gotten = CallRecordValidator.validate(call_record_with_nil_type)

      assert Enum.member?(call_record_without_type_gotten["errors"], expected_message_error)
      assert Enum.member?(call_record_with_empty_type_gotten["errors"], expected_message_error)
      assert Enum.member?(call_record_with_nil_type_gotten["errors"], expected_message_error)
    end
  end

end