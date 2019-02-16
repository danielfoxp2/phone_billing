defmodule BillingProcessor.Bills.ChargedMinutes do
  alias BillingProcessor.Bills.BillDetailsFormatter

  @one_minute_as_seconds 60

  def from(call) do
    call
    |> adjust_timestamp_call_to_charged_period()
    |> get_how_much_days_in()
    |> calculate_accountable_minutes_for()
  end

  defp adjust_timestamp_call_to_charged_period([%{timestamp: start_record_timestamp}, %{timestamp: end_record_timestamp}]) do
    start_date = adjusted_start_timestamp(start_record_timestamp)
    end_date = adjusted_end_timestamp(end_record_timestamp)

    [%{timestamp: start_date}, %{timestamp: end_date}]
  end

  defp adjusted_start_timestamp(start_record_timestamp) do
    six_am = "06"
    new_possible_start_record_timestamp = generate(six_am, start_record_timestamp)

    start_date = DateTime.compare(start_record_timestamp, new_possible_start_record_timestamp)
    |> return_start_time_for_this(start_record_timestamp, new_possible_start_record_timestamp)
  end

  defp adjusted_end_timestamp(end_record_timestamp) do
    ten_pm = "22"
    new_possible_end_record_timestamp = generate(ten_pm, end_record_timestamp) 

    end_date = DateTime.compare(end_record_timestamp, new_possible_end_record_timestamp)
    |> return_end_time_for_this(end_record_timestamp, new_possible_end_record_timestamp)
  end

  defp get_how_much_days_in([%{timestamp: start_record_timestamp}, %{timestamp: end_record_timestamp}] = call) do
    get_as_date(start_record_timestamp, end_record_timestamp)
    |> get_amount_of_days_between_end_and_start_date()
    |> mount_duration_for(call)
  end

  defp get_as_date(start_record_timestamp, end_record_timestamp) do
    {get_as_date(start_record_timestamp), get_as_date(end_record_timestamp)}
  end

  defp get_as_date(timestamp), do: DateTime.to_date(timestamp)

  defp get_amount_of_days_between_end_and_start_date({initial_day, end_day}) do
    adjust_day_to_not_exclude_itself = 1
    Date.diff(end_day, initial_day) + adjust_day_to_not_exclude_itself 
  end

  defp mount_duration_for(call_duration_in_days, call), do: [%{days: call_duration_in_days} | call]
    
  defp calculate_accountable_minutes_for([%{days: 2}, _, _] = call), do: adjust_start_time_limit(call)
  defp calculate_accountable_minutes_for([%{days: 1}, _, _] = call) do
    call
    |> adjust_start_time_limit()
    |> adjust_end_time_limit()
    |> get_duration_in_seconds()
    |> get_only_accountable_call_minutes()
  end
  defp calculate_accountable_minutes_for([days, start_record, end_record]) do
    first_and_last_day = 2
    amount_of_hour_in_a_full_day = 16
    one_hour_in_minutes = 60
    call = [%{days: 2}, start_record, end_record]
    full_days = days.days - first_and_last_day

    accountable_minutes_of_full_days = full_days * (amount_of_hour_in_a_full_day * one_hour_in_minutes)
    accountable_minutes_of_first_and_last_day = adjust_start_time_limit(call)

    accountable_minutes_of_full_days + accountable_minutes_of_first_and_last_day
  end

  defp adjust_start_time_limit([%{days: 1} = days, %{timestamp: start_record_timestamp}, end_record]) do
    adjusted_start_timestamp(start_record_timestamp)
    |> mount_start_result(end_record, days)
  end

  defp adjust_start_time_limit([%{days: 2}, %{timestamp: start_record_timestamp}, %{timestamp: end_record_timestamp}]) do
    minutos_do_primeiro_dia = montar_call_com_start_record_e_10_pm_como_end_record(start_record_timestamp)
    |> calcular_minutos

    minutos_do_segundo_dia = montar_call_com_6_am_como_start_e_end_record_timestamp(end_record_timestamp)
    |> calcular_minutos
    
    minutos_do_primeiro_dia + minutos_do_segundo_dia
  end

  defp montar_call_com_start_record_e_10_pm_como_end_record(start_record_timestamp) do
    ten_pm = "22"
    end_record_of_start_day = generate(ten_pm, start_record_timestamp)
    days = %{days: 1}
    first_day = [days, %{timestamp: start_record_timestamp}, %{timestamp: end_record_of_start_day}]
    adjust_start_time_limit(first_day)
  end

  defp montar_call_com_6_am_como_start_e_end_record_timestamp(end_record_timestamp) do
    six_am = "06"
    start_record_of_end_day = generate(six_am, end_record_timestamp)
    days = %{days: 1}
    last_day = [days, %{timestamp: start_record_of_end_day}, %{timestamp: end_record_timestamp}]
    adjust_start_time_limit(last_day)
  end

  defp calcular_minutos([_days | call_records_timestamps ]) do
    call_records_timestamps
    |> get_duration_in_seconds()
    |> get_only_accountable_call_minutes()
  end

  defp adjust_start_time_limit([days, %{timestamp: start_record_timestamp}, end_record]) do
    adjusted_start_timestamp(start_record_timestamp)
    |> mount_start_result(end_record, days)
  end

  defp adjust_end_time_limit([%{days: 1}, start_record, %{timestamp: end_record_timestamp}]) do
    adjusted_end_timestamp(end_record_timestamp)
    |> mount_end_result(start_record)
  end

  defp adjust_end_time_limit([%{days: 2}, start_record, %{timestamp: end_record_timestamp}]) do
    adjusted_end_timestamp(end_record_timestamp)
    |> mount_end_result(start_record)
  end

  defp adjust_end_time_limit([_dont_matter, start_record, %{timestamp: end_record_timestamp}]) do
    adjusted_end_timestamp(end_record_timestamp)
    |> mount_end_result(start_record)
  end

  defp generate(hour, date) do
    date_as_iso = "#{BillDetailsFormatter.format(date, :date_y_m_d)}T#{hour}:00:00Z"
    {:ok, converted_date, 0} = DateTime.from_iso8601(date_as_iso)
    
    converted_date
  end

  defp get_duration_in_seconds([start_record, end_record]) do
    DateTime.diff(end_record.timestamp, start_record.timestamp) 
  end

  defp get_only_accountable_call_minutes(from_call_duration_in_seconds) when from_call_duration_in_seconds < @one_minute_as_seconds, do: 0
  defp get_only_accountable_call_minutes(from_call_duration_in_seconds) do
    Integer.floor_div(from_call_duration_in_seconds, @one_minute_as_seconds)
  end

  defp return_start_time_for_this(:lt, _start_record_timestamp, six_am), do: six_am
  defp return_start_time_for_this(_equal_or_greater_result, start_record_timestamp, _six_am), do: start_record_timestamp
  
  defp return_end_time_for_this(:lt, end_record_timestamp, _ten_pm), do: end_record_timestamp
  defp return_end_time_for_this(_equal_or_greater_result, _end_record_timestamp, ten_pm), do: ten_pm

  defp mount_start_result(start_record_timestamp, end_record, days_in_call) do
    [days_in_call, %{timestamp: start_record_timestamp}, end_record]
  end

  defp mount_end_result(end_record_timestamp, start_record) do
    [start_record, %{timestamp: end_record_timestamp}]
  end

end