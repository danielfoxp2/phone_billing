defmodule BillingProcessor.Bills.CalculationOfDaysInterval do
  
  def in_this([%{timestamp: start_record_timestamp}, %{timestamp: end_record_timestamp}] = call) do
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
end