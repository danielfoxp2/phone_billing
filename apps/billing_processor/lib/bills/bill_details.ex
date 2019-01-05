defmodule BillingProcessor.Bills.BillDetails do
  alias BillingProcessor.Bills.CallDuration
  alias BillingProcessor.Bills.Callculator
  alias BillingProcessor.Bills.BillDetailsFormatter

  def build({calls, taxes}) do
    calls
    |> Map.values()
    |> Enum.map(fn call -> Task.async(fn -> mount_bill_detail_of(call, taxes) end) end)
    |> Enum.map(&Task.await/1)
  end

  defp mount_bill_detail_of([start_call_record, _end_call_record] = call, taxes) do
    %{
      destination: start_call_record.destination,
      call_start_date: BillDetailsFormatter.format(start_call_record.timestamp, :start_date), 
      call_start_time: BillDetailsFormatter.format(start_call_record.timestamp, :start_time),
      call_duration: get_formatted_duration_of(call),
      call_price: get_formatted_price_of(call, taxes)
    }
  end

  defp get_formatted_duration_of(call) do
    call
    |> CallDuration.of()
    |> BillDetailsFormatter.format(:duration)
  end

  defp get_formatted_price_of(call, taxes) do
    Callculator.get_total_of(call, taxes.standing_charge, taxes.call_charge)
    |> BillDetailsFormatter.format(:price)     
  end

end