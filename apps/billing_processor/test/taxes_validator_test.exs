defmodule BillingProcessor.TaxesValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.TaxesValidator

  describe "taxes" do
    test "should invalidate when reference period don't exists" do
      taxes_with_nil_reference_period = %{"reference_period" => nil}
      taxes_with_empty_reference_period = %{"reference_period" => ""}
      taxes_without_reference_period = %{}

      error_message = "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"
  
      taxes_with_nil_reference_and_error_message = TaxesValidator.validate(taxes_with_nil_reference_period)
      taxes_with_empty_reference_and_error_message = TaxesValidator.validate(taxes_with_empty_reference_period)
      taxes_with_empty_reference_and_error_message =  TaxesValidator.validate(taxes_without_reference_period)

      assert Enum.member?(taxes_with_nil_reference_and_error_message["errors"], error_message)
      assert Enum.member?(taxes_with_empty_reference_and_error_message["errors"], error_message)
      assert Enum.member?(taxes_with_empty_reference_and_error_message["errors"], error_message)
    end

    test "should invalidate when reference period has not MM/AAAA format" do
      params_with_invalid_reference = %{"reference_period" => "1/2018"}

      error_message = "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"

      taxes_with_empty_reference_and_error_message = TaxesValidator.validate(params_with_invalid_reference)
     
      assert Enum.member?(taxes_with_empty_reference_and_error_message["errors"], error_message)
    end

    test "should invalidate when standing charge don't exists" do
      taxes_with_nil_standing_charge = %{"standing_charge" => nil}
      taxes_with_empty_standing_charge = %{"standing_charge" => ""}
      taxes_without_standing_charge = %{}
      
      error_message = "The standing charge should be informed with key 'standing_charge'"
      expected_result_for_taxes_with_nil_standing_charge = %{"standing_charge" => nil, "errors" => [error_message]}
      expected_result_for_taxes_with_empty_standing_charge = %{"standing_charge" => "", "errors" => [error_message]}
      expected_result_for_taxes_without_standing_charge = %{"errors" => [error_message]}

      assert TaxesValidator.validate(taxes_with_nil_standing_charge) == expected_result_for_taxes_with_nil_standing_charge
      # assert TaxesValidator.validate(taxes_with_empty_standing_charge) == expected_result_for_taxes_with_empty_standing_charge
      # assert TaxesValidator.validate(taxes_without_standing_charge) == expected_result_for_taxes_without_standing_charge
    end

    # test "should invalidate if standing charge is not a number" do
    #   valid_standing_charge_as_string = %{"standing_charge" => "0.56"}
    #   valid_standing_charge_as_float = %{"standing_charge" => 0.47}
    #   valid_standing_charge_as_integer = %{"standing_charge" => 10}
    #   invalid_standing_charge_as_string = %{"standing_charge" => "xpto27"}

    #   error_message = "The standing charge should be a float number"

    #   expected_result_for_valid_standing_charge_as_string = %{"standing_charge" => "0.56"}
    #   expected_result_for_valid_standing_charge_as_float = %{"standing_charge" => 0.47}
    #   expected_result_for_valid_standing_charge_as_integer = %{"standing_charge" => 10}
    #   expected_result_for_invalid_standing_charge_as_string = %{"standing_charge" => "xpto27", "errors" => [error_message]}

    #   assert TaxesValidator.validate(valid_standing_charge_as_string) == expected_result_for_valid_standing_charge_as_string
    #   assert TaxesValidator.validate(valid_standing_charge_as_float) == expected_result_for_valid_standing_charge_as_float
    #   assert TaxesValidator.validate(valid_standing_charge_as_integer) == expected_result_for_valid_standing_charge_as_integer
    #   assert TaxesValidator.validate(invalid_standing_charge_as_string) == expected_result_for_invalid_standing_charge_as_string
    # end
  end
end