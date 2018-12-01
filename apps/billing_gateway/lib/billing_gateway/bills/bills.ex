defmodule BillingGateway.Bills do
  alias BillingProcessor.BillPhoneNumberValidator

  def calculate(bill_params) do
    get_phone_from(bill_params)
    |> BillPhoneNumberValidator.is_valid?
    |> calculate(bill_params)
  end

  defp get_phone_from(%{"phone_number" => phone_number}), do: phone_number
  defp get_phone_from(_bill_params), do: nil

  defp calculate({:invalid_phone_number, _} = processing_cant_proceed, _bill_params), do: processing_cant_proceed
  defp calculate({:ok}, bill_params) do

  end
end