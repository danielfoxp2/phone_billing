defmodule BillingProcessor.Bills.BillReference do
  
  @moduledoc """
  Responsible of getting the informed reference or the previous one if no reference is informed
  """

  @doc """
  When the user does not inform a reference to calculate the bill, this function returns the 
  previous reference of the current month, otherwise, it returns the informed reference.

  ## Parameters

    - params: a map containing the reference_period key informed by the client
    - current_reference: the current reference to be used to return the previous related reference if the client does not inform any reference_period
  
  ## Examples

  ### With reference period informed

      iex> params = %{"reference_period" => "11/2018"}
      iex> {:ok, current_reference} = Date.new(2019, 01, 01)
      iex> BillReference.get_last_month_if_needed(params, current_reference)
      %{"reference_period" => "11/2018"}

  ### Without reference period informed
    
      iex> params = %{}
      iex> {:ok, current_reference} = Date.new(2019, 01, 01)
      iex> BillReference.get_last_month_if_needed(params, current_reference)
      %{"reference_period" => "12/2018"}
  """
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