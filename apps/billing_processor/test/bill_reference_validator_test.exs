defmodule BillingProcessor.BillReferenceValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.BillReferenceValidator

  describe "a valid reference for bill calculation" do
    test "should invalidate when reference has not MM/AAAA format" do
      params_with_invalid_reference = %{"reference_period" => "1/2018"}

      error_message = "The bill calculation was not executed because reference has not the valid format of MM/AAAA or has invalid month"

      expected_result_for_invalid_reference = %{"reference_period" => "1/2018", "errors" => [error_message]}

      assert BillReferenceValidator.validate(params_with_invalid_reference) == expected_result_for_invalid_reference
    end

    test "should invalidate when reference month is not between 01 and 12" do
      params_with_invalid_zero_month = %{"reference_period" => "00/2018"}
      params_with_invalid_thirteen_month = %{"reference_period" => "13/2018"}

      error_message = "The bill calculation was not executed because reference has not the valid format of MM/AAAA or has invalid month"

      expected_result_for_invalid_zero_month = %{"reference_period" => "00/2018", "errors" => [error_message]}
      expected_result_for_invalid_thirteen_month = %{"reference_period" => "13/2018", "errors" => [error_message]}

      assert BillReferenceValidator.validate(params_with_invalid_zero_month) == expected_result_for_invalid_zero_month
      assert BillReferenceValidator.validate(params_with_invalid_thirteen_month) == expected_result_for_invalid_thirteen_month
    end

    test "should validate when reference has correct format and month" do
      params_with_valid_reference = %{"reference_period" => "07/2018"}

      expected_result_for_valid_reference =  %{"reference_period" => "07/2018"}

      assert BillReferenceValidator.validate(params_with_valid_reference) == expected_result_for_valid_reference
    end


  end
  
end