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

  defp get_time(seconds), do: Time.add(~T[00:00:00], seconds)

  defp get_result_from(time) do
    %{
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second
    }
  end
end