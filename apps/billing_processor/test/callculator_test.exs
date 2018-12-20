defmodule BillingProcessor.CallculatorTest do
  use ExUnit.Case
  alias BillingProcessor.Bills.Callculator
  
  describe "calculate bill for time call from 6:00 to 22:00 (excluding)" do
    test "that standing charge is the same regardless how much time it takes" do
      five_minutes_call = get_a_five_minutes_call()
      ten_minutes_call = get_a_ten_minutes_call()
      
      expect_result = 0.50
      standing_charge = 0.50
      call_charge = 0.00

      assert Callculator.get_total_of(five_minutes_call, standing_charge, call_charge) == expect_result
      assert Callculator.get_total_of(ten_minutes_call, standing_charge, call_charge) == expect_result
    end

    test "that call charges is charged by each closed sixty seconds" do
      five_minutes_call = get_a_five_minutes_call()
      ten_minutes_call = get_a_ten_minutes_call()

      expect_result_for_five_minutes_call = 0.45
      expect_result_for_ten_minutes_call = 0.90

      standing_charge = 0.00
      call_charge = 0.09

      assert Callculator.get_total_of(five_minutes_call, standing_charge, call_charge) == expect_result_for_five_minutes_call
      assert Callculator.get_total_of(ten_minutes_call, standing_charge, call_charge) == expect_result_for_ten_minutes_call
    end

    test "that the total amount of the bill is the sum of the call charge and standing charge" do
      ten_minutes_call = get_a_ten_minutes_call()

      expect_result_for_ten_minutes_call = 5.36
      standing_charge = 0.36
      call_charge = 0.50

      assert Callculator.get_total_of(ten_minutes_call, standing_charge, call_charge) == expect_result_for_ten_minutes_call
    end

    defp get_a_five_minutes_call() do
      [
        %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T20:50:00Z")},
        %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-31T20:55:00Z")}
      ]
    end

    defp get_a_ten_minutes_call() do
      [
        %{type: "start", call_id: 2, timestamp: get_date_time("2018-10-31T20:50:00Z")},
        %{type: "end", call_id: 2, timestamp: get_date_time("2018-10-31T21:00:00Z")}
      ]
    end

    defp get_date_time(date) do
      {:ok, converted_date, 0} = DateTime.from_iso8601(date)
      converted_date
    end
  end
end