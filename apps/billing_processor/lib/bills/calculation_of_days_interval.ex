defmodule BillingProcessor.Bills.CalculationOfDaysInterval do
  @moduledoc """
  Calculates the interval of days between the start and end of a call
  """

  @doc """

  Calculates the interval of days between the start and end of a call

  ## Parameters

    call: is a list containing a call record of type `start` and a call record with type `end`
  
  ## Examples

      iex> {:ok, start_record_timestamp, 0} = DateTime.from_iso8601("2018-10-25T21:50:00Z")
      iex> {:ok, end_record_timestamp, 0} = DateTime.from_iso8601("2018-10-27T22:10:00Z")
      
      iex> start_and_end_call_records = [
      >   %{type: "start", call_id: 1, destination: 6298457834, timestamp: start_record_timestamp},
      >   %{type: "end", call_id: 1, timestamp: end_record_timestamp}
      > ]

      iex> CalculationOfDaysInterval.in_this(start_and_end_call_records)
      [ 
        %{days: 3},
        [
          %{type: "start", call_id: 1, destination: 6298457834, timestamp: start_record_timestamp},
          %{type: "end", call_id: 1, timestamp: end_record_timestamp}
        ]
      ]
  """
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