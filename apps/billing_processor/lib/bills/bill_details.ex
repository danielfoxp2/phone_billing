defmodule BillingProcessor.Bills.BillDetails do
  alias BillingProcessor.Bills.CallDuration
  alias BillingProcessor.Bills.Callculator

  def build({calls, taxes}) do
    calls
    |> Map.values()
    |> Enum.map(fn call -> metodo(call, taxes) end)
  end

  defp metodo([start_call_record, _end_call_record] = call, taxes) do
    %{
      destination: start_call_record.destination,
      call_start_date: "#{start_call_record.timestamp.day}-#{start_call_record.timestamp.month}-#{start_call_record.timestamp.year}",
      call_start_time: "#{format(start_call_record.timestamp.hour)}:#{format(start_call_record.timestamp.minute)}:#{format(start_call_record.timestamp.second)}",
      call_duration: get_formatted_duration_of(call),
      call_price: get_formatted_price_of(call, taxes)
    }
  end

  defp get_formatted_duration_of(call) do
    call_duration = CallDuration.of(call)
    "#{call_duration.hours}h#{format(call_duration.minutes)}m#{format(call_duration.seconds)}s"
  end

  defp get_formatted_price_of(call, taxes) do
    price = "#{Callculator.get_total_of(call, taxes.standing_charge, taxes.call_charge)}"
    |> String.replace(".", ",")

    "R$ #{price}"
  end

  defp format(value), do: String.pad_leading("#{value}", 2, "0")

end