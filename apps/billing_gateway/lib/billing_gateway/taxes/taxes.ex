defmodule BillingGateway.Taxes do
  alias BillingRepository.Bills.TariffRepository
  alias BillingProcessor.TaxesValidator

  def create(taxes_params) do
    taxes_params
    |> TaxesValidator.validate()
    |> insert_new_taxes_when_there_is_no_error()
  end

  defp insert_new_taxes_when_there_is_no_error(%{"errors" => errors_reasons}), do: {:taxes_error, errors_reasons}
  defp insert_new_taxes_when_there_is_no_error(taxes), do: TariffRepository.insert_new(taxes)

end