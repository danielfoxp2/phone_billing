defmodule BillingProcessor.BillPhoneNumberValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.BillPhoneNumberValidator

  describe "a valid phone number for bill calculation" do
    test "should invalidate when phone has not AAXXXXXXXX or AAXXXXXXXXX format" do
      nil_phone_number = nil
      empty_phone_number = ""
      invalid_phone_number = "2342x"

      expected_result = {:invalid_phone_number, "The bill calculation was not executed because phone number was not informed"}
      
      assert BillPhoneNumberValidator.is_valid?(nil_phone_number) == expected_result
      assert BillPhoneNumberValidator.is_valid?(empty_phone_number) == expected_result
      assert BillPhoneNumberValidator.is_valid?(invalid_phone_number) == expected_result
    end

    test "should validate when phone number has AAXXXXXXXX or AAXXXXXXXXX format" do
      phone_number_with_ten_digits = "6234568956"
      phone_number_with_eleven_digits = "62984680648"

      expected_result = {:ok}

      assert BillPhoneNumberValidator.is_valid?(phone_number_with_ten_digits) == expected_result
      assert BillPhoneNumberValidator.is_valid?(phone_number_with_eleven_digits) == expected_result
    end
    
  end
end