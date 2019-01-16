defmodule BillingProcessor.Bills.BillDetailsFormatter do
  
  def format(date, :date_y_m_d), do: "#{format(date.year)}-#{format(date.month)}-#{format(date.day)}"
  def format(start, :start_date), do: "#{format(start.day)}-#{format(start.month)}-#{format(start.year)}"
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