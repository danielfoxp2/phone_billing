defmodule BillingProcessor.BillPhoneNumberValidator do
  
  @moduledoc false
  
  @error_message "The bill calculation was not executed because phone number is invalid or not informed"

  def validate(%{"phone_number" => nil} = bill_params), do: mount_error_in(bill_params)
  def validate(%{"phone_number" => ""} = bill_params), do: mount_error_in(bill_params)
  def validate(%{"phone_number" => phone_number} = bill_params), do: validate_allowed_range_of(phone_number, bill_params)
  def validate(bill_params), do: mount_error_in(bill_params)

  defp validate_allowed_range_of(phone_number, bill_params) do
    only_integer_with_ten_or_eleven_digits_regex = ~r/^\d{10,11}+$/
    
    phone_number
    |> has_match?(only_integer_with_ten_or_eleven_digits_regex)
    |> mount_error_if_doesnt_match(bill_params)
  end

  defp has_match?(phone_number, with_allowed_range_regex), do: Regex.match?(with_allowed_range_regex, "#{phone_number}")

  defp mount_error_if_doesnt_match(true, bill_params), do: bill_params
  defp mount_error_if_doesnt_match(false, bill_params), do: mount_error_in(bill_params)

  defp mount_error_in(bill_params) do
    errors = Map.get(bill_params, "errors", [])
    Map.put(bill_params, "errors", [@error_message] ++ errors)
  end

end