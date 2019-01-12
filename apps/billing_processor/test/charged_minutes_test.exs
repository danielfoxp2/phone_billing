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

  describe "charged minutes from call when call starts after 21:59:59 in one day but ends before 06:00:00 of the next day" do
    test "should return zero minutes because it is in reduced time" do
      call = get_a_call_starting_after_10_pm_but_ending_before_6_am()
      expected_result = 0

      assert ChargedMinutes.from(call) == expected_result
    end
  end

  describe "charged minutes from call when call starts before 22:00:00 in one day and ends after 06:00:00 of the next day" do
    test "should return only accountable minutes of each day" do
      call = get_a_call_starting_9_50_pm_and_ending_8_10_am_of_the_next_day()
      expected_result = 140

      assert ChargedMinutes.from(call) == expected_result
    end
  end

  describe "charged minutes from call when call traverse multiples days" do
    test "should return only accountable minutes of each traversed day" do
      call = get_a_call_starting_9_pm_of_one_day_and_ending_11_am_five_days_later()
      expected_result_in_minutes = 3240

      assert ChargedMinutes.from(call) == expected_result_in_minutes
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

  defp get_a_call_starting_after_10_pm_but_ending_before_6_am() do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T23:50:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-11-01T00:08:05Z")}
    ]
  end

  defp get_a_call_starting_9_50_pm_and_ending_8_10_am_of_the_next_day do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T21:50:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-11-01T08:10:05Z")}
    ]
  end

  defp get_a_call_starting_9_pm_of_one_day_and_ending_11_am_five_days_later do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T21:00:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-11-04T11:00:05Z")}
    ]
  end

  defp get_date_time(date) do
    {:ok, converted_date, 0} = DateTime.from_iso8601(date)
    converted_date
  end
end