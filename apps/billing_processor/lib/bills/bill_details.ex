defmodule BillingProcessor.Bills.BillDetails do
  alias BillingProcessor.Bills.CallDuration
  alias BillingProcessor.Bills.Callculator
  alias BillingProcessor.Bills.BillDetailsFormatter

  @moduledoc """
  Build details of a bill with the given calls
  """

  @doc """
  From the given tuple with grouped calls and the charged tariffs it will mount the information of calls in the bill

  ## Parameters
    
    A tuple with:

    - grouped_calls: a map with a list of `call_records` grouped by `call_id`. Each grouped call_records contains a start and end record in a list.
    - taxes: a map with the billed tariffs. 

  ## Examples

      iex> {:ok, start_record_timestamp, 0} = DateTime.from_iso8601("2018-10-25T21:50:00Z")
      iex> {:ok, end_record_timestamp, 0} = DateTime.from_iso8601("2018-10-25T22:10:00Z")
      
      iex> start_and_end_call_records = [
      >   %{type: "start", call_id: 1, destination: 6298457834, timestamp: start_record_timestamp},
      >   %{type: "end", call_id: 1, timestamp: end_record_timestamp}
      > ]
      
      iex> grouped_calls = %{ 1 => start_and_end_call_records }
      iex> taxes = %{standing_charge: 0.36, call_charge: 0.50}
      
      iex> BillDetails.build({grouped_calls, taxes})
      %{
        bill_total: "R$ 5,36", 
        bill_details: [
          %{
            destination: 6298457834,
            call_start_date: "25-10-2018",
            call_start_time: "21:50:00",
            call_duration: "0h20m00s",
            call_price: "R$ 5,36"
          }
        ]
      }
  
  """
  def build({grouped_calls, taxes}) do
    grouped_calls
    |> get_all_calls()
    |> mount_bill_details(taxes)
    |> format_total_of()
  end

  defp get_all_calls(grouped_calls), do: Map.values(grouped_calls) 

  defp mount_bill_details(calls, taxes) do
    initial_bill_details = %{bill_total: 0, bill_details: []}
    
    Enum.reduce(calls, initial_bill_details, fn call, %{bill_total: bill_total, bill_details: bill_details} -> 
      mount_bill(call, bill_total, bill_details, taxes)
    end)
  end

  defp mount_bill(call, bill_total, bill_details, taxes) do
    call_price = Callculator.get_total_of(call, taxes.standing_charge, taxes.call_charge)
    bill_total = bill_total + get_in_cents(call_price)
    bill_details = bill_details ++ [mount_bill_detail_of(call, call_price)]

    %{bill_total: bill_total, bill_details: bill_details}
  end

  defp mount_bill_detail_of([start_call_record, _end_call_record] = call, call_price) do
    %{
      destination: start_call_record.destination,
      call_start_date: BillDetailsFormatter.format(start_call_record.timestamp, :start_date), 
      call_start_time: BillDetailsFormatter.format(start_call_record.timestamp, :start_time),
      call_duration: get_formatted_duration_of(call),
      call_price: BillDetailsFormatter.format(call_price, :price)
    }
  end

  defp get_formatted_duration_of(call) do
    call
    |> CallDuration.of()
    |> BillDetailsFormatter.format(:duration)
  end

  defp format_total_of(bill), do: Map.update!(bill, :bill_total, &format/1)
  defp format(bill_total) do
    get_in_reais(bill_total)
    |> BillDetailsFormatter.format(:price)
  end

  defp get_in_cents(call_price), do: call_price * 100
  defp get_in_reais(bill_total), do: bill_total / 100
end