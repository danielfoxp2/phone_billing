defmodule BillingProcessor.TaxesValidator do
  alias BillingProcessor.BillReferenceValidator

  @reference_period_message "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"
  @standing_charge_message "The standing charge should be informed with key 'standing_charge'"
  @standing_charge_number_message "The standing charge should be a float number"

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

  def validate(%{"standing_charge" => ""} = taxes, _field) do
    include(@standing_charge_message, taxes)
  end

  def validate(taxes, "reference_period" = field) do
    taxes
    |> Map.get(field)
    |> is_valid?(taxes)
  end

  def validate(taxes, "standing_charge" = field) do
    taxes
    |> Map.get(field)
    |> is_valid_stading_charge?(taxes)
  end

  defp is_valid?(reference, taxes) when is_nil(reference), do: include(@reference_period_message, taxes)
  defp is_valid?(reference, taxes) do
    reference
    |> BillReferenceValidator.is_valid?()
    |> mount_error_if_needed(taxes, @reference_period_message)
  end

  defp is_valid_stading_charge?(standing_charge, taxes) when is_nil(standing_charge), do: include(@standing_charge_message, taxes)
  defp is_valid_stading_charge?(standing_charge, taxes) do
    standing_charge
    |> is_number?() 
    |> mount_error_if_needed(taxes, @standing_charge_number_message)
  end

  defp is_number?(standing_charge) do
    float_number_regex = ~r/^[0-9]+.[0-9]+$/
    Regex.match?(float_number_regex, "#{standing_charge}")
  end

  defp mount_error_if_needed(true, taxes, _error_message), do: taxes
  defp mount_error_if_needed(false, taxes, error_message), do: include(error_message, taxes) 
  
  defp include(error_message, in_taxes) do
    errors = Map.get(in_taxes, "errors", [])
    Map.put(in_taxes, "errors", [error_message] ++ errors)
  end
end