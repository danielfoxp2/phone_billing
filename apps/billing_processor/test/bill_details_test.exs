defmodule BillingProcessor.BillDetailsTest do
  use ExUnit.Case
  alias BillingProcessor.Bills.BillDetails

  describe "Details of bill" do
    test "should mount the details of each call of the bill" do
      calls = get_calls()
      taxes = %{standing_charge: 0.36, call_charge: 0.50}
      expected_result = [get_first_bill_detail(), get_second_bill_detail()]

      assert BillDetails.build({calls, taxes}) == expected_result
    end
  end

  defp get_calls() do
    %{
      1 => get_first_call(),
      2 => get_second_call()
    }
  end

  defp get_first_call() do
    [
      %{type: "start", call_id: 1, destination: 6298457834, timestamp: get_date_time("2018-10-25T21:50:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-25T22:10:00Z")}
    ]
  end

  defp get_second_call() do
    [
      %{type: "start", call_id: 2, destination: 6298457834, timestamp: get_date_time("2018-10-31T18:50:00Z")},
      %{type: "end", call_id: 2, timestamp: get_date_time("2018-10-31T19:10:00Z")}
    ]
  end

  defp get_date_time(date) do
    {:ok, converted_date, 0} = DateTime.from_iso8601(date)
    converted_date
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