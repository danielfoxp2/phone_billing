defmodule BillingProcessor.DuplicationValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.DuplicationValidator

  describe "call record id duplication checking" do
    test "that its add an error message when there are duplicated call record id within call records to be persisted" do
      duplicated_id = "1"
      duplicated_persisted_call_records = [id: "3"]
      call_records = [%{"id" => duplicated_id}, %{"id" => duplicated_id}, %{"id" => "2"}]

      error_message = "call record with id: #{duplicated_id} is duplicated in call records being inserted"
            
      expected_call_records = [%{"id" => "1", "errors" => [error_message]}, %{"id" => "1", "errors" => [error_message]}, %{"id" => "2"}]
      actual_result = DuplicationValidator.check_duplicates_in(duplicated_persisted_call_records, call_records)

      assert actual_result == expected_call_records
    end

    test "that its add an error message when already exists the same call record id persisted" do
      duplicated_id = "1"
      duplicated_persisted_call_records = [id: duplicated_id]
      call_records = [%{"id" => duplicated_id}, %{"id" => "2"}]
      error_message = "call record with id: #{duplicated_id} already exists in database"

      expected_call_records = [%{"id" => duplicated_id, "errors" => [error_message]}, %{"id" => "2"}]
      actual_result = DuplicationValidator.check_duplicates_in(duplicated_persisted_call_records, call_records)

      assert actual_result == expected_call_records
    end

    test "should do nothing when there is no id in call record" do
      duplicated_persisted_call_records = [id: "1"]

      call_records = [%{"id" => ""}, %{"call_id" => "2"}, %{"id" => nil}]
      expected_call_records = [%{"id" => ""}, %{"call_id" => "2"}, %{"id" => nil}]

      actual_result = DuplicationValidator.check_duplicates_in(duplicated_persisted_call_records, call_records)

      assert actual_result == expected_call_records
    end
  end

  describe "call record call_id duplication checking" do
    test "that its add an error message when there are more than two call ids with the same value within call records to be persisted" do
      duplicated_call_id = "1"
      duplicated_persisted_call_records = [call_id: "3"]
      call_records = [%{"call_id" => duplicated_call_id}, %{"call_id" => duplicated_call_id}, %{"call_id" => "2"}, %{"call_id" => duplicated_call_id}]

      error_message = "call record with call_id: #{duplicated_call_id} is duplicated in call records being inserted"
            
      expected_call_records = [%{"call_id" => "1", "errors" => [error_message]}, %{"call_id" => "1", "errors" => [error_message]}, %{"call_id" => "2"}, %{"call_id" => "1", "errors" => [error_message]}]
      actual_result = DuplicationValidator.check_duplicates_in(duplicated_persisted_call_records, call_records)

      assert actual_result == expected_call_records
    end

    test "that its add an error message when already exists the same call record call_id persisted" do
      duplicated_call_id = 1
      duplicated_persisted_call_records = [call_id: duplicated_call_id]
      call_records = [%{"call_id" => duplicated_call_id}, %{"call_id" => duplicated_call_id}, %{"call_id" => 2}]
      error_message = "call record with call_id: #{duplicated_call_id} already exists in database"

      expected_call_records = [%{"call_id" => duplicated_call_id, "errors" => [error_message]}, %{"call_id" => duplicated_call_id, "errors" => [error_message]}, %{"call_id" => 2}]
      actual_result = DuplicationValidator.check_duplicates_in(duplicated_persisted_call_records, call_records)

      assert actual_result == expected_call_records
    end

    test "should do nothing when there is no call_id in call record" do
      duplicated_persisted_call_records = [call_id: 1]

      call_records = [%{"call_id" => ""}, %{"id" => "2"}, %{"call_id" => nil}]
      expected_call_records = [%{"call_id" => ""}, %{"id" => "2"}, %{"call_id" => nil}]

      actual_result = DuplicationValidator.check_duplicates_in(duplicated_persisted_call_records, call_records)

      assert actual_result == expected_call_records
    end
  end 

end