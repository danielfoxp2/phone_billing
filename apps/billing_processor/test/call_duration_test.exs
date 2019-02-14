defmodule BillingProcessor.CallDurationTest do
  use ExUnit.Case
  alias BillingProcessor.Bills.CallDuration

  describe "A duration of call when it is less than 24 hours" do
    test "should calculate the seconds quantity" do
      call = get_call()

      expected_result = 17
      %{seconds: seconds} = CallDuration.of(call)

      assert seconds == expected_result
    end

    test "should calculate the minutes quantity" do
      call = get_call()

      expected_result = 5
      %{minutes: minutes} = CallDuration.of(call)

      assert minutes == expected_result
    end

    test "should calculate the hours quantity" do
      call = get_call()

      expected_result = 1
      %{hours: hours} = CallDuration.of(call)

      assert hours == expected_result
    end

    test "should calculate the complete duration" do
      call = another_call()

      expected_result = %{hours: 1, minutes: 45, seconds: 25}

      assert CallDuration.of(call) == expected_result
    end
  end

  describe "A duration of call when it is bigger than 24 hours" do
    test "should calculate the complete duration" do
      call = get_call_with_24_hours_and_13_minutes_43_seconds()

      expected_result = %{hours: 24, minutes: 13, seconds: 43}

      assert CallDuration.of(call) == expected_result
    end
  end

  defp get_call() do
    [
      %{type: "start", call_id: 1, timestamp: get_date_time("2018-10-31T20:50:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-31T21:55:17Z")}
    ]
  end

  defp another_call() do
    [
      %{type: "start", call_id: 2, timestamp: get_date_time("2018-10-31T20:50:00Z")},
      %{type: "end", call_id: 2, timestamp: get_date_time("2018-10-31T22:35:25Z")}
    ]
  end

  defp get_call_with_24_hours_and_13_minutes_43_seconds() do
    [
      %{type: "start", call_id: 2, timestamp: get_date_time("2017-12-13T21:57:13Z")},
      %{type: "end", call_id: 2, timestamp: get_date_time("2017-12-14T22:10:56Z")}
    ]
  end 

  defp get_date_time(date) do
    {:ok, converted_date, 0} = DateTime.from_iso8601(date)
    converted_date
  end

end