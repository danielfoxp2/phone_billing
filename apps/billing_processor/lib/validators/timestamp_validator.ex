defmodule BillingProcessor.TimestampValidator do
  
  @moduledoc false
  
  def check_consistence_of(timestamp) do
    timestamp
    |> NaiveDateTime.from_iso8601
    |> is_invalid?
  end
  
  defp is_invalid?({:ok, _}), do: false
  defp is_invalid?({:error, _}), do: true

end