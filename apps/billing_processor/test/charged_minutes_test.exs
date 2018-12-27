defmodule BillingProcessor.ChargedMinutesTest do
  use ExUnit.Case
  alias BillingProcessor.Bills.ChargedMinutes
  
  describe "charged minutes from call when call starts after 05:59:59" do
    test "should return all minutes" do
      call = get_a_five_minutes_call_in_stardard_time_call()
      expected_result = 5

      assert ChargedMinutes.from(call) == expected_result
    end
  end

  describe "charged minutes from call when call ends before 22:00:00" do
    test "should return all minutes" do
      call = get_a_six_minutes_call_in_stardard_time_call()
      expected_result = 6

      assert ChargedMinutes.from(call) == expected_result
    end
  end

  describe "charged minutes from call when call ends after 21:59:59" do
    test "should return only full minutes before 22:00:00" do
      call = get_a_call_ending_after_10_pm()
      expected_result = 2

      assert ChargedMinutes.from(call) == expected_result
    end
  end

  describe "charged minutes from call when call starts before 06:00:00" do
    test "should return only the minutes after 05:59:59" do
      call = get_a_call_starting_before_6_am()
      expected_result = 5

      assert ChargedMinutes.from(call) == expected_result
    end
  end

  defp get_a_five_minutes_call_in_stardard_time_call() do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T06:00:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-31T06:05:00Z")}
    ]
  end

  defp get_a_six_minutes_call_in_stardard_time_call() do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T21:53:59Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-31T21:59:59Z")}
    ]
  end

  defp get_a_call_ending_after_10_pm() do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T21:57:13Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-31T22:17:53Z")}
    ]
  end

  defp get_a_call_starting_before_6_am() do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T05:55:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-31T06:05:00Z")}
    ]
  end

  defp get_date_time(date) do
    {:ok, converted_date, 0} = DateTime.from_iso8601(date)
    converted_date
  end
end