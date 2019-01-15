defmodule BillingProcessor.BillReferenceTest do
  use ExUnit.Case
  alias BillingProcessor.Bills.BillReference

  describe "bill reference when user informed something" do
    test "should return the informed reference" do
      params = %{"reference_period" => "11/2018"}
      {:ok, current_reference} = Date.new(2019, 01, 01)
      expected_reference = %{"reference_period" => "11/2018"}

      assert BillReference.get_last_month_if_needed(params, current_reference) == expected_reference
    end
  end

  describe "bill reference when user not informed reference" do
    test "should return the last closed reference" do
      params_without_reference_key = %{}
      params_with_nil_reference = %{"reference_period" => nil}
      params_with_empty_reference = %{"reference_period" => ""}
      {:ok, current_reference} = Date.new(2019, 01, 01)
      expected_reference = %{"reference_period" => "12/2018"}

      assert BillReference.get_last_month_if_needed(params_without_reference_key, current_reference) == expected_reference
      assert BillReference.get_last_month_if_needed(params_with_nil_reference, current_reference) == expected_reference
      assert BillReference.get_last_month_if_needed(params_with_empty_reference, current_reference) == expected_reference
    end
  end
end