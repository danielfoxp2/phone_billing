defmodule BillingGateway.Taxes do
  alias BillingRepository.Bills.TariffRepository
  alias BillingProcessor.TaxesReferenceValidator
  alias BillingProcessor.TaxesValidator

  def create(taxes_params) do
    taxes_params
    |> TaxesValidator.validate()
    |> validate_if_reference_can_be_updated()
    |> insert_new_taxes_when_there_is_no_error()
  end

  defp validate_if_reference_can_be_updated(taxes_params) do
    TariffRepository.get_taxes(taxes_params)
    |> TaxesReferenceValidator.validate(taxes_params)
  end

  defp insert_new_taxes_when_there_is_no_error(%{"errors" => errors_reasons}), do: {:taxes_error, errors_reasons}
  defp insert_new_taxes_when_there_is_no_error(taxes), do: TariffRepository.insert_new(taxes)

end