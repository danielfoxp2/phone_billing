defmodule BillingProcessor.BillDetailsTest do
  use ExUnit.Case
  alias BillingProcessor.Bills.BillDetails
  alias BillingProcessor.Support.CallFixture

  describe "Details of bill" do
    test "should mount the details of each call of the bill" do
      calls = CallFixture.get_calls()
      taxes = %{standing_charge: 0.36, call_charge: 0.50}
      expected_result = [get_first_bill_detail(), get_second_bill_detail()]

      assert BillDetails.build({calls, taxes}) == expected_result
    end
  end

  defp get_first_bill_detail() do
    %{
      destination: 6298457834,
      call_start_date: "25-10-2018",
      call_start_time: "21:50:00",
      call_duration: "0h20m00s",
      call_price: "R$ 5,36"
    }
  end

  defp get_second_bill_detail() do
    %{
      destination: 6298457834,
      call_start_date: "31-10-2018",
      call_start_time: "18:50:00",
      call_duration: "0h20m00s",
      call_price: "R$ 10,36"
    }
  end

end