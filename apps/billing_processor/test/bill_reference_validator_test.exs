defmodule BillingProcessor.BillReferenceValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.BillReferenceValidator

  describe "a valid reference for bill calculation" do
    test "should invalidate when reference has not MM/AAAA format" do
      params_with_invalid_reference = %{"reference" => "1/2018"}

      error_message = "The bill calculation was not executed because reference has not the valid format of MM/AAAA"

      expected_result_for_invalid_reference = %{"reference" => "1/2018", "errors" => [error_message]}

      assert BillReferenceValidator.validate(params_with_invalid_reference) == expected_result_for_invalid_reference
    end


    
  end
  
end