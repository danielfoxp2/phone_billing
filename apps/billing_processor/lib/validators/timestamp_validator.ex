defmodule BillingProcessor.TimestampValidator do
  
  def check_consistence_of(timestamp) do
    timestamp
    |> NaiveDateTime.from_iso8601
    |> is_valid?
  end
  
  defp is_valid?({:ok, _}), do: true
  defp is_valid?({:error, _}), do: false

end