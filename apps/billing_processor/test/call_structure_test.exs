defmodule BillingProcessor.CallStructureTest do
  use ExUnit.Case
  alias BillingProcessor.CallStructure

  describe "the correct structure of a complete call" do
    test "add error when a call has a call records pair with the same type" do
      call_id = 1
      call_records = [%{"call_id" => call_id, "type" => "start"}, %{"call_id" => call_id, "type" => "start"}]

      error_message = "Inconsistent call for call_id '#{call_id}'. A call is a composition of two record types, 'start' and 'end', with the same call id."

      expected_call_records = [%{"call_id" => call_id, "type" => "start", "errors" => [error_message]}, %{"call_id" => call_id, "type" => "start", "errors" => [error_message]}]

      actual_result = CallStructure.validate_pair_of(call_records)

      assert actual_result == expected_call_records
    end

    test "don't add error when a call has a call record without call id value" do
      call_record_without_call_id_key = [%{"type" => "start"}]
      call_record_with_empty_call_id = [%{"call_id" => "", "type" => "start"}]
      call_record_with_nil_call_id = [%{"call_id" => nil, "type" => "start"}]

      expected_call_record_without_call_id_key = [%{"type" => "start"}]
      expected_call_record_with_empty_call_id = [%{"call_id" => "", "type" => "start"}]
      expected_call_record_with_nil_call_id = [%{"call_id" => nil, "type" => "start"}]

      actual_result_call_record_without_call_id_key = CallStructure.validate_pair_of(call_record_without_call_id_key)
      actual_result_call_record_with_empty_call_id = CallStructure.validate_pair_of(call_record_with_empty_call_id)
      actual_result_call_record_with_nil_call_id = CallStructure.validate_pair_of(call_record_with_nil_call_id)

      assert actual_result_call_record_without_call_id_key == expected_call_record_without_call_id_key
      assert actual_result_call_record_with_empty_call_id == expected_call_record_with_empty_call_id
      assert actual_result_call_record_with_nil_call_id == expected_call_record_with_nil_call_id
    end

  end
end