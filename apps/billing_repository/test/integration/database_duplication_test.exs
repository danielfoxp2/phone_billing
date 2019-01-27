defmodule DatabaseDuplicationTest do
  use ExUnit.Case
  alias BillingRepository.DatabaseDuplication

  test "should ignore call records without call_id" do
    call_records = [%{"call_id" => 1}, %{}, %{"call_id" => nil}, %{"call_id" => ""} ]
    expected_result = {[call_id: 1], [%{"call_id" => 1}, %{}, %{"call_id" => nil}, %{"call_id" => ""}]}

    duplicated_keys = DatabaseDuplication.search_for(call_records)

    assert duplicated_keys == expected_result
  end

  test "should return a call record id for a given id if it is duplicated" do
    call_records = [%{"id" => 1}]
    expected_result = {[id: "1"], [%{"id" => 1}]}

    duplicated_keys = DatabaseDuplication.search_for(call_records)

    assert duplicated_keys == expected_result
  end

  test "should return a call_id of a call record for a given call_id if it is duplicated" do
    call_records = [%{"call_id" => 1}]
    expected_result = {[call_id: 1], [%{"call_id" => 1}]}

    duplicated_keys = DatabaseDuplication.search_for(call_records)

    assert duplicated_keys == expected_result
  end

  test "should return the duplicated records given a list of ids or call_ids" do
    call_records = [%{"id" => 1, "call_id" => 1}, %{"id" => 3, "call_id" => 2}]
    expected_result = {[id: "1", call_id: 1, id: "3", call_id: 2], [%{"id" => 1, "call_id" => 1}, %{"id" => 3, "call_id" => 2}]}

    duplicated_keys = DatabaseDuplication.search_for(call_records)

    assert duplicated_keys == expected_result
  end

end