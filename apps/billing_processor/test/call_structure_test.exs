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

    test "add error when a call has a call record without type value" do
      call_id = 1
      call_record_without_type_key = [%{"call_id" => call_id}]
      call_record_with_empty_type = [%{"call_id" => call_id, "type" => ""}]
      call_record_with_nil_type = [%{"call_id" => call_id, "type" => nil}]

      error_message = "Inconsistent call for call_id '#{call_id}'. A call is a composition of two record types, 'start' and 'end', with the same call id."

      expected_call_record_without_type_key = [%{"call_id" => call_id, "errors" => [error_message]}]
      expected_call_record_with_empty_type = [%{"call_id" => call_id, "type" => "", "errors" => [error_message]}]
      expected_call_record_with_nil_type = [%{"call_id" => call_id, "type" => nil, "errors" => [error_message]}]

      actual_result_call_record_without_type_key = CallStructure.validate_pair_of(call_record_without_type_key)
      actual_result_call_record_with_empty_type = CallStructure.validate_pair_of(call_record_with_empty_type)
      actual_result_call_record_with_nil_type = CallStructure.validate_pair_of(call_record_with_nil_type)

      assert actual_result_call_record_without_type_key == expected_call_record_without_type_key
      assert actual_result_call_record_with_empty_type == expected_call_record_with_empty_type
      assert actual_result_call_record_with_nil_type == expected_call_record_with_nil_type
    end

    test "don't add error when a call has a valid structure" do
      call_records_of_call = [%{"call_id" => 1, "type" => "start"}, %{"call_id" => 1, "type" => "end"}]

      expected_call_records_of_call = [%{"call_id" => 1, "type" => "start"}, %{"call_id" => 1, "type" => "end"}]

      actual_result_call_records_of_call = CallStructure.validate_pair_of(call_records_of_call)

      assert actual_result_call_records_of_call == expected_call_records_of_call
    end

  end
end