defmodule BillingGateway.Bills do
  alias BillingProcessor.BillPhoneNumberValidator
  alias BillingProcessor.BillReferenceValidator
  alias BillingRepository.CallRecordRepository
  alias BillingRepository.Bills.TariffRepository
  alias BillingProcessor.Bills.FullBill
  alias BillingProcessor.Bills.BillReference

  @moduledoc """
  Orchestrates the flow of bill calculation
  """

  @doc """
  Given a bill params, it calls the responsibles for:
  
  - get the reference to calculate the bill;
  - validates the given phone number;
  - validates the given reference;
  - calculates the bill;

  ## Parameters

    A map with the following structure:

    - phone number: a String with ten or eleven digits;
    - reference period (optional): a String in the format `"MM/yyyy"`.

  ## Examples

      iex> bill_params = %{"phone_number" => "62984680648", "reference_period" => "11/2018"}
      iex> Bills.calculate(bill_params)
      > %{
      >   "phone_number" => "62984680648", 
      >   "reference_period" => "11/2018",
      >   "bill" => %{
      >     "bill_total" => "R$ 0,54",
      >     "bill_details" => [
      >       %{
      >         "destination" => 6298457834,
      >         "call_start_date" => "23-11-2018",
      >         "call_start_time" => "21:57:13",
      >         "call_duration" => "0h20m40s",
      >         "call_price" => "R$ 0,54"
      >       }
      >     ]
      >   }
      > }
  """

  def calculate(bill_params) do
    bill_params
    |> BillReference.get_last_month_if_needed(Date.utc_today())
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