defmodule BillingProcessor.TaxesValidator do
  alias BillingProcessor.BillReferenceValidator

  @reference_period_message "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"

  def validate(%{"reference_period" => nil} = taxes) do
    include(@reference_period_message, taxes)
  end

  def validate(%{"reference_period" => ""} = taxes) do
    include(@reference_period_message, taxes)
  end

  def validate(taxes) do
    taxes
    |> Map.get("reference_period")
    |> is_valid(taxes)
  end

  defp is_valid(reference, taxes) when is_nil(reference), do: include(@reference_period_message, taxes)
  defp is_valid(reference, taxes) do
    BillReferenceValidator.is_valid?(reference)
    |> mount_error_if_needed(taxes)
  end

  defp mount_error_if_needed(true, taxes), do: taxes
  defp mount_error_if_needed(false, taxes), do: include(@reference_period_message, taxes) 
  
  defp include(error_message, in_taxes) do
    errors = Map.get(in_taxes, "errors", [])
    Map.put(in_taxes, "errors", [error_message] ++ errors)
  end
end