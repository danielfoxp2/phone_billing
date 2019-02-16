defmodule BillingProcessor.Bills.BillReference do
  
  def get_last_month_if_needed(%{"reference_period" => nil} = params, current_reference) do
    put_last_reference_in(params, current_reference)
  end

  def get_last_month_if_needed(%{"reference_period" => ""} = params, current_reference) do 
    put_last_reference_in(params, current_reference)
  end

  def get_last_month_if_needed(%{"reference_period" => _reference_period} = params, _current_reference), do: params
  def get_last_month_if_needed(params, current_reference), do: put_last_reference_in(params, current_reference)

  defp put_last_reference_in(params, current_reference) do
    current_reference
    |> get_last_reference_from()
    |> update_reference_of(params)
  end

  defp get_last_reference_from(current_reference) do
    previous_date = Date.add(current_reference, -31)
    month = "#{previous_date.month}"
    year = previous_date.year
    "#{String.pad_leading(month, 2, "0")}/#{year}"
  end

  defp update_reference_of(last_reference, params), do: Map.put(params, "reference_period", last_reference)
  
end