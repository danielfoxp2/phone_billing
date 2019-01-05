defmodule BillingProcessor.Support.CallFixture do
  
  def get_calls() do
    %{
      1 => get_first_call(),
      2 => get_second_call()
    }
  end

  defp get_first_call() do
    [
      %{type: "start", call_id: 1, destination: 6298457834, timestamp: get_date_time("2018-10-25T21:50:00Z")},
      %{type: "end", call_id: 1, timestamp: get_date_time("2018-10-25T22:10:00Z")}
    ]
  end

  defp get_second_call() do
    [
      %{type: "start", call_id: 2, destination: 6298457834, timestamp: get_date_time("2018-10-31T18:50:00Z")},
      %{type: "end", call_id: 2, timestamp: get_date_time("2018-10-31T19:10:00Z")}
    ]
  end

  defp get_date_time(date) do
    {:ok, converted_date, 0} = DateTime.from_iso8601(date)
    converted_date
  end
end