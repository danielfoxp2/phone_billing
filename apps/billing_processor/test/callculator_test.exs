defmodule BillingProcessor.CallculatorTest do
  use ExUnit.Case
  
  describe "calculate bill for time call from 6:00 to 22:00 (excluding)" do
    test "that standing charge is the same regardless how much time it takes" do
      five_minutes_call = [%{type: "start", call_id: 1, timestamp: ~N[2018-10-31T20:50:00]},
                           %{type: "end", call_id: 1, timestamp: ~N[2018-10-31T20:55:00]}]
      
      ten_minutes_call = [%{type: "start", call_id: 2, timestamp: ~N[2018-10-31T20:50:00]},
                          %{type: "end", call_id: 2, timestamp: ~N[2018-10-31T21:00:00]}]
      expect_result = 0.50

      standing_charge = 0.50
      call_charge = 0.00

      assert Callculator.get_total_of(five_minutes_call, standing_charge, call_charge) == expect_result
      assert Callculator.get_total_of(ten_minutes_call, standing_charge, call_charge) == expect_result
    end

    test "that call charges is charged by each closed sixty seconds" do
      five_minutes_call = [%{type: "start", call_id: 1, timestamp: ~N[2018-10-31T20:50:00]},
                           %{type: "end", call_id: 1, timestamp: ~N[2018-10-31T20:55:00]}]
      
      ten_minutes_call = [%{type: "start", call_id: 2, timestamp: ~N[2018-10-31T20:50:00]},
                          %{type: "end", call_id: 2, timestamp: ~N[2018-10-31T21:00:00]}]

      expect_result_for_five_minutes_call = 0.45
      expect_result_for_ten_minutes_call = 0.90

      standing_charge = 0.00
      call_charge = 0.09

      assert Callculator.get_total_of(five_minutes_call, standing_charge, call_charge) == expect_result_for_five_minutes_call
      assert Callculator.get_total_of(ten_minutes_call, standing_charge, call_charge) == expect_result_for_ten_minutes_call
    end

    test "that the total amount of the bill is the sum of the call charge and standing charge" do
      ten_minutes_call = [%{type: "start", call_id: 2, timestamp: ~N[2018-10-31T20:50:00]},
                          %{type: "end", call_id: 2, timestamp: ~N[2018-10-31T21:00:00]}]

      expect_result_for_ten_minutes_call = 5.36
      standing_charge = 0.36
      call_charge = 0.50

      assert Callculator.get_total_of(ten_minutes_call, standing_charge, call_charge) == expect_result_for_ten_minutes_call
    end
  end
end