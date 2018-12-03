defmodule BillingProcessor.BillPhoneNumberValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.BillPhoneNumberValidator

  describe "a valid phone number for bill calculation" do
    test "should invalidate when phone has not AAXXXXXXXX or AAXXXXXXXXX format" do
      params_without_phone_number_key = %{}
      params_with_nil_phone_number = %{"phone_number" => nil}
      params_with_empty_phone_number = %{"phone_number" => ""}
      params_with_invalid_phone_number = %{"phone_number" => "2342x"}

      error_message = "The bill calculation was not executed because phone number was not informed"
      expected_result_for_inexistent_key = %{"errors" => [error_message]}
      expected_result_for_nil_number = %{"phone_number" => nil, "errors" => [error_message]}
      expected_result_for_empty_number = %{"phone_number" => "", "errors" => [error_message]}
      expected_result_for_invalid_number = %{"phone_number" => "2342x", "errors" => [error_message]}
      
      assert BillPhoneNumberValidator.validate(params_without_phone_number_key) == expected_result_for_inexistent_key
      assert BillPhoneNumberValidator.validate(params_with_nil_phone_number) == expected_result_for_nil_number
      assert BillPhoneNumberValidator.validate(params_with_empty_phone_number) == expected_result_for_empty_number
      assert BillPhoneNumberValidator.validate(params_with_invalid_phone_number) == expected_result_for_invalid_number
    end

    # test "should validate when phone number has AAXXXXXXXX or AAXXXXXXXXX format" do
    #   params_with_phone_number_with_ten_digits = %{"phone_number" => "6234568956"}
    #   params_phone_number_with_eleven_digits = %{"phone_number" => "62984680648"}

    #   expected_result_number_with_ten_digits = %{"phone_number" => "6234568956"}
    #   expected_result_number_eleven_digits = %{"phone_number" => "62984680648"}

    #   assert BillPhoneNumberValidator.validate(params_with_phone_number_with_ten_digits) == expected_result_number_with_ten_digits
    #   assert BillPhoneNumberValidator.validate(params_phone_number_with_eleven_digits) == expected_result_number_eleven_digits
    # end
    
  end
end