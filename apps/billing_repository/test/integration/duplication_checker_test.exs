defmodule DuplicationCheckerTest do
  use ExUnit.Case
  alias BillingRepository.DuplicationChecker

  test "should return a call record id for a given id if it is duplicated" do
    call_records = [%{"id" => 1}]
    expected_result = [[id: 1]]

    duplicated_keys = DuplicationChecker.for(call_records)

    assert duplicated_keys == expected_result
  end
end