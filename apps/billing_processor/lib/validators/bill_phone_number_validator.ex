defmodule BillingProcessor.BillPhoneNumberValidator do
  
  @error_message "The bill calculation was not executed because phone number was not informed"

  def is_valid?(nil), do: {:invalid_phone_number, @error_message}
  def is_valid?(""), do: {:invalid_phone_number, @error_message}
  def is_valid?(true), do: {:invalid_phone_number, @error_message}
  def is_valid?(false), do: {:ok}
  def is_valid?(phone_number) do
    only_integer_with_ten_or_eleven_digits_regex = ~r/^\d{10,11}+$/
    validation_phone_number = Regex.match?(only_integer_with_ten_or_eleven_digits_regex, "#{phone_number}") == false

    validation_phone_number |> is_valid?
  end

end