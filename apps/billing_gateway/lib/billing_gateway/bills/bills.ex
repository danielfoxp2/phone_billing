defmodule BillingGateway.Bills do
  alias BillingProcessor.BillPhoneNumberValidator
  alias BillingProcessor.BillReferenceValidator

  def calculate(bill_params) do
    bill_params
    |> BillPhoneNumberValidator.validate()
    |> BillReferenceValidator.validate()
    |> calculate_bill()
  end

  defp calculate_bill(%{"errors" => _errors} = bill_params), do: {:bill_creation_error, bill_params}
  defp calculate_bill(bill_params) do
    {:ok, "bill"}
  end
end