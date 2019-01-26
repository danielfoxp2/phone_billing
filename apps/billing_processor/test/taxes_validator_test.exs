defmodule BillingProcessor.TaxesValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.TaxesValidator

  @expected_message_occurrences 1

  describe "taxes" do
    test "should invalidate when reference period don't exists" do
      taxes_with_nil_reference_period = %{"reference_period" => nil}
      taxes_with_empty_reference_period = %{"reference_period" => ""}
      taxes_without_reference_period = %{}

      error_message = "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"
  
      taxes_with_nil_reference_and_error_message = TaxesValidator.validate(taxes_with_nil_reference_period)
      taxes_with_empty_reference_and_error_message = TaxesValidator.validate(taxes_with_empty_reference_period)
      taxes_without_reference_and_error_message =  TaxesValidator.validate(taxes_without_reference_period)

      expected_error_message_for_nil_reference = Enum.filter(taxes_with_nil_reference_and_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_empty_reference = Enum.filter(taxes_with_empty_reference_and_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_no_reference = Enum.filter(taxes_without_reference_and_error_message["errors"], fn message -> message == error_message end)

      assert Enum.count(expected_error_message_for_nil_reference) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_empty_reference) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_no_reference) == @expected_message_occurrences
    end

    test "should invalidate when reference period has not MM/AAAA format" do
      params_with_invalid_reference = %{"reference_period" => "1/2018"}

      error_message = "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"

      taxes_with_invalid_reference_and_error_message = TaxesValidator.validate(params_with_invalid_reference)
     
      expected_error_message_for_invalid_reference = Enum.filter(taxes_with_invalid_reference_and_error_message["errors"], fn message -> message == error_message end)
      
      assert Enum.count(expected_error_message_for_invalid_reference) == @expected_message_occurrences
    end

    test "should invalidate when standing charge don't exists" do
      taxes_with_nil_standing_charge = %{"standing_charge" => nil}
      taxes_with_empty_standing_charge = %{"standing_charge" => ""}
      taxes_without_standing_charge = %{}
      
      error_message = "The standing charge should be informed with key 'standing_charge'"

      taxes_with_nil_standing_charge_and_error_message = TaxesValidator.validate(taxes_with_nil_standing_charge)
      taxes_with_empty_standing_charge_and_error_message = TaxesValidator.validate(taxes_with_empty_standing_charge)
      taxes_without_standing_charge_and_error_message = TaxesValidator.validate(taxes_without_standing_charge)

      expected_error_message_for_nil_standing_charge = Enum.filter(taxes_with_nil_standing_charge_and_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_empty_standing_charge = Enum.filter(taxes_with_empty_standing_charge_and_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_no_standing_charge = Enum.filter(taxes_without_standing_charge_and_error_message["errors"], fn message -> message == error_message end)

      assert Enum.count(expected_error_message_for_nil_standing_charge) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_empty_standing_charge) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_no_standing_charge) == @expected_message_occurrences
    end

    test "should invalidate if standing charge is not a number" do
      valid_standing_charge_as_string = %{"standing_charge" => "0.56"}
      valid_standing_charge_as_float = %{"standing_charge" => 0.47}
      invalid_standing_charge_as_integer = %{"standing_charge" => 10}
      invalid_standing_charge_as_string = %{"standing_charge" => "xpto27"}

      error_message = "The standing charge should be a float number"

      valid_standing_charge_as_string_without_error_message = TaxesValidator.validate(valid_standing_charge_as_string)
      valid_standing_charge_as_float_without_error_message = TaxesValidator.validate(valid_standing_charge_as_float)
      invalid_standing_charge_as_integer_with_error_message = TaxesValidator.validate(invalid_standing_charge_as_integer)
      invalid_standing_charge_as_string_with_error_message = TaxesValidator.validate(invalid_standing_charge_as_string)

      expected_error_message_for_invalid_standing_charge_as_integer = Enum.filter(invalid_standing_charge_as_integer_with_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_standing_charge_as_string = Enum.filter(invalid_standing_charge_as_string_with_error_message["errors"], fn message -> message == error_message end)

      assert Enum.member?(valid_standing_charge_as_string_without_error_message["errors"], error_message) == false
      assert Enum.member?(valid_standing_charge_as_float_without_error_message["errors"], error_message) == false
      assert Enum.count(expected_error_message_for_invalid_standing_charge_as_integer) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_standing_charge_as_string) == @expected_message_occurrences
    end

    test "should invalidate when call charge don't exists" do
      taxes_with_nil_call_charge = %{"call_charge" => nil}
      taxes_with_empty_call_charge = %{"call_charge" => ""}
      taxes_without_call_charge = %{}
      
      error_message = "The call charge should be informed with key 'call_charge'"

      taxes_with_nil_call_charge_and_error_message = TaxesValidator.validate(taxes_with_nil_call_charge)
      taxes_with_empty_call_charge_and_error_message = TaxesValidator.validate(taxes_with_empty_call_charge)
      taxes_without_call_charge_and_error_message = TaxesValidator.validate(taxes_without_call_charge)

      expected_error_message_for_nil_call_charge = Enum.filter(taxes_with_nil_call_charge_and_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_empty_call_charge = Enum.filter(taxes_with_empty_call_charge_and_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_no_call_charge = Enum.filter(taxes_without_call_charge_and_error_message["errors"], fn message -> message == error_message end)

      assert Enum.count(expected_error_message_for_nil_call_charge) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_empty_call_charge) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_no_call_charge) == @expected_message_occurrences
    end

    test "should invalidate if call charge is not a number" do
      valid_call_charge_as_string = %{"call_charge" => "0.56"}
      valid_call_charge_as_float = %{"call_charge" => 0.47}
      invalid_call_charge_as_integer = %{"call_charge" => 10}
      invalid_call_charge_as_string = %{"call_charge" => "xpto27"}

      error_message = "The call charge should be a float number"

      valid_call_charge_as_string_without_error_message = TaxesValidator.validate(valid_call_charge_as_string)
      valid_call_charge_as_float_without_error_message = TaxesValidator.validate(valid_call_charge_as_float)
      invalid_call_charge_as_integer_without_error_message = TaxesValidator.validate(invalid_call_charge_as_integer)
      invalid_call_charge_as_string_with_error_message = TaxesValidator.validate(invalid_call_charge_as_string)

      expected_error_message_for_call_charge_as_integer = Enum.filter(invalid_call_charge_as_integer_without_error_message["errors"], fn message -> message == error_message end)
      expected_error_message_for_call_charge_as_string = Enum.filter(invalid_call_charge_as_string_with_error_message["errors"], fn message -> message == error_message end)

      assert Enum.member?(valid_call_charge_as_string_without_error_message["errors"], error_message) == false
      assert Enum.member?(valid_call_charge_as_float_without_error_message["errors"], error_message) == false
      assert Enum.count(expected_error_message_for_call_charge_as_integer) == @expected_message_occurrences
      assert Enum.count(expected_error_message_for_call_charge_as_string) == @expected_message_occurrences
    end
  end
end