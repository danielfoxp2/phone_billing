defmodule BillingProcessor.BillReferenceValidator do
  
  @moduledoc false
  
  @error_message "The bill calculation was not executed because reference has not the valid format of MM/AAAA or has invalid month"

  def validate(%{"reference_period" => reference} = bill_params) do
    reference
    |> valid_format?()
    |> valid_month?()
    |> mount_error_if_needed(bill_params)
  end

  def is_valid?(reference) do
    reference
    |> valid_format?()
    |> valid_month?()
  end

  defp valid_format?(reference) do
    mm_aaaa_format_regex = ~r/^\d{2}\/\d{4}+$/
    is_valid = Regex.match?(mm_aaaa_format_regex, reference)

    {is_valid, reference}
  end

  defp valid_month?({false, _reference}), do: false
  defp valid_month?({true, reference}) do
    {month, _} = get_month_from(reference)
    
    month >= 1 && month <= 12 
  end

  defp get_month_from(reference) do
    String.split(reference, "/") 
    |> List.first
    |> Integer.parse
  end

  defp mount_error_if_needed(true, bill_params), do: bill_params
  defp mount_error_if_needed(false, bill_params) do 
    errors = Map.get(bill_params, "errors", [])
    Map.put(bill_params, "errors", [@error_message] ++ errors)
  end

end