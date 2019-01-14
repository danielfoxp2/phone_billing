defmodule BillingGateway.Bills do
  alias BillingProcessor.BillPhoneNumberValidator
  alias BillingProcessor.BillReferenceValidator
  alias BillingRepository.CallRecordRepository
  alias BillingRepository.Bills.TariffRepository
  alias BillingProcessor.Bills.FullBill

  def calculate(bill_params) do
    bill_params
    |> BillPhoneNumberValidator.validate()
    |> BillReferenceValidator.validate()
    |> calculate_bill()
  end

  defp calculate_bill(%{"errors" => _errors} = bill_params), do: {:bill_creation_error, bill_params}
  defp calculate_bill(bill_params) do
    taxes = TariffRepository.get_taxes(bill_params)

    Task.start(fn -> TariffRepository.insert_taxes_if_needed_for(bill_params["reference_period"]) end)

    bill_params
    |> CallRecordRepository.get_calls()
    |> FullBill.build(taxes, bill_params)
  end
end