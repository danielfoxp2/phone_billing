defmodule BillingProcessor.Bills.FullBill do
  alias BillingProcessor.Bills.BillDetails

  def build(grouped_calls, taxes, bill_params) do
    {:ok, mount_bill(grouped_calls, taxes, bill_params)}
  end

  defp mount_bill(grouped_calls, taxes, bill_params) do
    %{
      phone_number: bill_params["phone_number"],
      reference_period: bill_params["reference_period"],
      bill: BillDetails.build({grouped_calls, taxes})
    }
  end
end