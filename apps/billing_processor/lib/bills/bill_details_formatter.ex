defmodule BillingProcessor.Bills.BillDetailsFormatter do
  
  @moduledoc """
  Responsible for format data
  """

  @doc """
  Format a data that complies with the given atom

  ## Parameters

    - data: a data to be formatted
    - atom: an atom that defines for which format to parse

  ### Accepted data:
    
    - Any data structure that has a day, month and year properties accessible via dot notation
    - Any data structure that has a hour, minute and second properties accessible via dot notation
    - Any data structure that has a hours, minutes and seconds properties accessible via dot notation
    - A float 

  ### Accepted atoms:
    - :start_date
    - :date_y_m_d
    - :start_time
    - :duration
    - :price

  ## Examples
    
  ### :start_date

      iex> {:ok, date, 0} = DateTime.from_iso8601("2018-10-25T22:10:00Z")
      iex> BillDetailsFormatter.format(date, :start_date)
      "25-10-2018"

  ### :date_y_m_d

      iex> {:ok, date, 0} = DateTime.from_iso8601("2018-10-25T22:10:00Z")
      iex> BillDetailsFormatter.format(date, :start_date)
      "2018-10-25"

  ### :start_time

      iex> {:ok, datetime, 0} = DateTime.from_iso8601("2018-10-25T22:10:00Z")
      iex> BillDetailsFormatter.format(datetime, :start_time)
      "22:10:00"

  ### :duration

      iex> call_duration = %{hours: 20, minutes: 10, seconds: 09}
      iex> BillDetailsFormatter.format(datetime, :duration)
      "22h:10m:00s"
  
  ### :price

      iex> call_duration = 19.25
      iex> BillDetailsFormatter.format(datetime, :price)
      "R$ 19,25"
  """
  def format(start, :start_date), do: "#{format(start.day)}-#{format(start.month)}-#{format(start.year)}"
  def format(date, :date_y_m_d), do: "#{format(date.year)}-#{format(date.month)}-#{format(date.day)}"
  def format(start, :start_time), do: "#{format(start.hour)}:#{format(start.minute)}:#{format(start.second)}"
  def format(call_duration, :duration) do
    "#{call_duration.hours}h#{format(call_duration.minutes)}m#{format(call_duration.seconds)}s"
  end
  def format(price, :price) do
    price
    |> Float.to_string()
    |> String.pad_trailing(4, "0")
    |> String.replace(".", ",")
    |> get_currency()
  end

  defp format(time), do: String.pad_leading("#{time}", 2, "0")

  defp get_currency(of_price), do: "R$ #{of_price}" 
end