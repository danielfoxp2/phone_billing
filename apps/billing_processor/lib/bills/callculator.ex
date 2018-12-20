defmodule BillingProcessor.Bills.Callculator do
  
  def get_total_of(call, standing_charge, charge_per_minute) do
    call
    |> get_duration_in_seconds()
    |> get_only_accountable_call_minutes()
    |> calculate_total_minutes_cost_with_this(charge_per_minute)
    |> sum_charged_minutes_with(standing_charge)
  end

  defp get_duration_in_seconds([start_record, end_record]) do
    DateTime.diff(end_record.timestamp, start_record.timestamp) 
  end

  defp get_only_accountable_call_minutes(from_call_duration_in_seconds) do
    one_minute = 60
    Integer.floor_div(from_call_duration_in_seconds, one_minute)
  end

  defp calculate_total_minutes_cost_with_this(by_minutes, charge_per_minute) do
    charge_per_minute
    |> transform_in_cents()
    |> multiply(by_minutes)
    |> transform_back_to_reais()
  end

  defp sum_charged_minutes_with(total_per_minute, and_standing_charge) do
    total_per_minute + and_standing_charge
  end

  defp transform_in_cents(this_charge_per_minute), do: this_charge_per_minute * 100
  defp multiply(charge_per_minute, by_minute), do: charge_per_minute * by_minute
  defp transform_back_to_reais(total_call_charge), do: total_call_charge / 100

end