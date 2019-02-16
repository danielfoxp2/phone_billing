defmodule BillingProcessor.Bills.FullBill do
  alias BillingProcessor.Bills.BillDetails

  @moduledoc false
  
  def build(grouped_calls, %{standing_charge: _standing_charge} = taxes, bill_params) do
    {:ok, mount_bill(grouped_calls, taxes, bill_params)}
  end
  def build(_grouped_calls, _taxes, _bill_params), do: {:error, :unset_taxes}

  defp mount_bill(grouped_calls, taxes, bill_params) do
    %{
      phone_number: bill_params["phone_number"],
      reference_period: bill_params["reference_period"],
      bill: BillDetails.build({grouped_calls, taxes})
    }
  end
end