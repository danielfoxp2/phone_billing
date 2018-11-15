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
      call_record = [%{"type" => "start"}]

      expected_call_record = [%{"type" => "start"}]

      actual_result = CallStructure.validate_pair_of(call_record)

      assert actual_result == expected_call_record
    end

  end
end