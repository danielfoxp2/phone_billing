defmodule BillingProcessor.DuplicationValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.DuplicationValidator

  describe "call record id duplication checking" do
    test "that its add an error message when already exists persisted the same call record id" do
      duplicated_id = "1"
      duplicated_persisted_call_records = [id: duplicated_id]
      call_records = [%{"id" => duplicated_id}, %{"id" => "2"}]
      error_message = "call record with id: #{duplicated_id} already exists in database"

      expected_call_records = [%{"id" => duplicated_id, "errors" => [error_message]}, %{"id" => "2"}]
      actual_result = DuplicationValidator.check_duplicates_in(duplicated_persisted_call_records, call_records)

      assert actual_result == expected_call_records
    end
  end
end