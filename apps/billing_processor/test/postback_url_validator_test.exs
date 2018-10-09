defmodule BillingProcessor.PostbackUrlValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.PostbackUrlValidator
  doctest PostbackUrlValidator

  @expected_error_message "The processing was not executed because postback url was not informed"
  
  describe "postback url validator" do
    test "should invalidate when postback url key not exists" do
      assert PostbackUrlValidator.is_valid?(nil) == {:postback_url_error, @expected_error_message} 
    end

    test "should invalidate when postback url is empty" do
      assert PostbackUrlValidator.is_valid?("") == {:postback_url_error, @expected_error_message} 
    end

    test "should validate when some value is passed" do
      postback_url = "www.example.com"
      assert PostbackUrlValidator.is_valid?(postback_url) == {:ok, postback_url} 
    end
  end
 
end