defmodule BillingProcessor.Bills.CallDuration do
  
  def of(call) do
    call
    |> get_duration_in_seconds()
    |> get_time()
    |> get_result_from()
  end

  defp get_duration_in_seconds([start_record, end_record]) do
    DateTime.diff(end_record.timestamp, start_record.timestamp) 
  end

  defp get_time(seconds) when seconds < 86400, do: Time.add(~T[00:00:00], seconds)
  defp get_time(seconds) do
    minutes_and_seconds = Time.add(~T[00:00:00], seconds)
    hours =  Integer.floor_div(seconds, 86400) * 24

    %{hour: hours, minute: minutes_and_seconds.minute, second: minutes_and_seconds.second}
  end

  defp get_result_from(time) do
    %{
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second
    }
  end
end