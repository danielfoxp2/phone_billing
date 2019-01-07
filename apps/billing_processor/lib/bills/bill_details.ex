defmodule BillingProcessor.Bills.BillDetails do
  alias BillingProcessor.Bills.CallDuration
  alias BillingProcessor.Bills.Callculator
  alias BillingProcessor.Bills.BillDetailsFormatter

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