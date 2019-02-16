defmodule BillingGateway.Taxes do
  alias BillingRepository.Bills.TariffRepository
  alias BillingProcessor.TaxesReferenceValidator
  alias BillingProcessor.TaxesValidator

  @moduledoc """
    Assure execution of taxes business before calling its insertion.
  """

  @doc """
  Call validation of taxes, reference period and if everything is right call the responsible to persist taxes. 

  ## Examples

      iex> taxes_params = %{"reference_period" => "11/2018", "standing_charge" => "0.05", "call_charge" => "0.14"}
      iex> Taxes.create(taxes_params)
      {:ok, "Taxes inserted"}
  """
  def create(taxes_params) do
    taxes_params
    |> TaxesValidator.validate()
    |> validate_if_reference_can_be_updated()
    |> insert_new_taxes_when_there_is_no_error()
  end

  defp validate_if_reference_can_be_updated(%{"errors" => _errors} = taxes_params), do: taxes_params
  defp validate_if_reference_can_be_updated(taxes_params) do
    TariffRepository.get_taxes(taxes_params)
    |> TaxesReferenceValidator.validate(taxes_params)
  end

  defp insert_new_taxes_when_there_is_no_error(%{"errors" => errors_reasons}), do: {:taxes_error, errors_reasons}
  defp insert_new_taxes_when_there_is_no_error(taxes), do: TariffRepository.insert_new(taxes)

end