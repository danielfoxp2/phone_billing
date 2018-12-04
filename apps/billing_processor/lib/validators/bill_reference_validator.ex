defmodule BillingProcessor.BillReferenceValidator do
  
  @error_message "The bill calculation was not executed because reference has not the valid format of MM/AAAA"

  def validate(%{"reference" => reference} = bill_params) do
    mm_aaaa_format_regex = ~r/^\d{2}\/\d{4}+$/

    Regex.match?(mm_aaaa_format_regex, reference)
    |> mount_error_if_needed(bill_params)
  end

  defp mount_error_if_needed(true, bill_params), do: bill_params
  defp mount_error_if_needed(false, bill_params) do 
    errors = Map.get(bill_params, "errors", [])
    Map.put(bill_params, "errors", [@error_message] ++ errors)
  end

end