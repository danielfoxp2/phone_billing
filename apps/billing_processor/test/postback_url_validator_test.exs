defmodule BillingProcessor.PostbackUrlValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.PostbackUrlValidator
  doctest PostbackUrlValidator

  describe "postback url validator" do
    test "should invalidate when postback url key not exists" do
      expected_error_message = "The processing was not executed because postback url was not informed"
      assert PostbackUrlValidator.is_valid?(nil) == {:error, expected_error_message} 
    end

    test "should invalidate when postback url is empty" do
      expected_error_message = "The processing was not executed because postback url was not informed"
      assert PostbackUrlValidator.is_valid?("") == {:error, expected_error_message} 
    end

    test "should validate when some value is passed" do
      postback_url = "www.example.com"
      assert PostbackUrlValidator.is_valid?(postback_url) == {:ok, postback_url} 
    end
  end
 
end