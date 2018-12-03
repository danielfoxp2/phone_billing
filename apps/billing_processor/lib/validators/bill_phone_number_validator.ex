defmodule BillingProcessor.BillPhoneNumberValidator do
  
  @error_message "The bill calculation was not executed because phone number was not informed"

  def validate(%{"phone_number" => nil} = bill_params), do: mount_error_in(bill_params)
  def validate(%{"phone_number" => ""} = bill_params), do: mount_error_in(bill_params)
  def validate(%{"phone_number" => phone_number} = bill_params), do: validate_allowed_range_of(phone_number, bill_params)
  def validate(bill_params), do: mount_error_in(bill_params)

  defp validate_allowed_range_of(phone_number, bill_params) do
    only_integer_with_ten_or_eleven_digits_regex = ~r/^\d{10,11}+$/
    variavel = Regex.match?(only_integer_with_ten_or_eleven_digits_regex, "#{phone_number}") == false
    
    is_in_the_allowed_range?(variavel, bill_params)
  end

  defp is_in_the_allowed_range?(false, bill_params), do: bill_params
  defp is_in_the_allowed_range?(true, bill_params), do: mount_error_in(bill_params)

  defp mount_error_in(bill_params) do
    errors = Map.get(bill_params, "errors", [])
    Map.put(bill_params, "errors", [@error_message] ++ errors)
  end

end