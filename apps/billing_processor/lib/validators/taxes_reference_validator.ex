defmodule BillingProcessor.TaxesReferenceValidator do
  
  def validate(%{reference_period: reference_from_database}, taxes_params) do
    get_current_reference()
    |> is_greater_than?(reference_from_database)
    |> mount_error_for(taxes_params)
  end
  def validate(_reference_from_database, taxes_params), do: taxes_params

  defp get_current_reference() do
    today = Date.utc_today()
    {current_reference, _not_used} = Integer.parse("#{today.year}#{String.pad_leading("#{today.month}", 2, "0")}")
    current_reference
  end

  defp is_greater_than?(current_reference, reference_to_be_inserted) do
    current_reference > reference_to_be_inserted
  end

  defp mount_error_for(false, in_taxes), do: in_taxes
  defp mount_error_for(true, in_taxes) do
    error_message = "It is not allowed the update of taxes before the current reference"
    errors = Map.get(in_taxes, "errors", [])
    Map.put(in_taxes, "errors", [error_message] ++ errors)
  end

end