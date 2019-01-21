defmodule BillingProcessor.TaxesValidator do
  alias BillingProcessor.BillReferenceValidator

  @reference_period_message "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"
  @standing_charge_message "The standing charge should be informed with key 'standing_charge'"

  def validate(taxes) do
    taxes
    |> validate("reference_period")
    |> validate("standing_charge")
  end

  def validate(%{"reference_period" => nil} = taxes, _field) do
    include(@reference_period_message, taxes)
  end

  def validate(%{"reference_period" => ""} = taxes, _field) do
    include(@reference_period_message, taxes)
  end

  def validate(%{"standing_charge" => nil} = taxes, _field) do
    include(@standing_charge_message, taxes)
  end

  def validate(taxes, field) do
    taxes
    |> Map.get(field)
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