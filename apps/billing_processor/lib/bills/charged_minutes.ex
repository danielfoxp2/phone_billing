defmodule BillingProcessor.Bills.ChargedMinutes do
  
  def from(call) do
    call
    |> adjust_start_time_limit()
    |> adjust_end_time_limit()
    |> get_duration_in_seconds()
    |> get_only_accountable_call_minutes()
  end

  defp adjust_start_time_limit([%{timestamp: start_record_timestamp}, end_record]) do
    six_am = "06"
    new_possible_start_record_timestamp = generate(six_am, start_record_timestamp) 
    
    DateTime.compare(start_record_timestamp, new_possible_start_record_timestamp)
    |> return_start_time_for_this(start_record_timestamp, new_possible_start_record_timestamp)
    |> mount_start_result(end_record)
  end

  defp adjust_end_time_limit([start_record, %{timestamp: end_record_timestamp}]) do
    ten_pm = "22"
    new_possible_end_record_timestamp = generate(ten_pm, end_record_timestamp) 

    DateTime.compare(end_record_timestamp, new_possible_end_record_timestamp)
    |> return_end_time_for_this(end_record_timestamp, new_possible_end_record_timestamp)
    |> mount_end_result(start_record)
  end

  defp generate(hour, date) do
    date_as_iso = "#{date.year}-#{date.month}-#{date.day}T#{hour}:00:00Z"
    {:ok, converted_date, 0} = DateTime.from_iso8601(date_as_iso)

    converted_date
  end

  defp get_duration_in_seconds([start_record, end_record]) do
    DateTime.diff(end_record.timestamp, start_record.timestamp) 
  end

  defp get_only_accountable_call_minutes(from_call_duration_in_seconds) do
    one_minute = 60
    Integer.floor_div(from_call_duration_in_seconds, one_minute)
  end

  defp return_start_time_for_this(:lt, start_record_timestamp, six_am), do: six_am
  defp return_start_time_for_this(equal_or_greater_result, start_record_timestamp, six_am), do: start_record_timestamp
  
  defp return_end_time_for_this(:lt, end_record_timestamp, ten_pm), do: end_record_timestamp
  defp return_end_time_for_this(equal_or_greater_result, end_record_timestamp, ten_pm), do: ten_pm

  defp mount_start_result(start_record_timestamp, end_record) do
    [%{timestamp: start_record_timestamp}, end_record]
  end

  defp mount_end_result(end_record_timestamp, start_record) do
    [start_record, %{timestamp: end_record_timestamp}]
  end

end