defmodule BillingProcessor.Bills.ChargedMinutes do
  alias BillingProcessor.Bills.BillDetailsFormatter

  # def from(call) do
  #   call
  #   |> adjust_start_time_limit()
  #   |> adjust_end_time_limit()
  #   |> get_duration_in_seconds()
  #   |> get_only_accountable_call_minutes()
  # end

  def from(call) do
    call
    |> get_how_much_days_in()
    |> calculate_accountable_minutes_for()
    # |> adjust_start_time_limit()
    # |> adjust_end_time_limit()
    # |> get_duration_in_seconds()
    # |> get_only_accountable_call_minutes()
  end

  defp get_how_much_days_in([%{timestamp: start_record_timestamp}, %{timestamp: end_record_timestamp}] = call) do
    cosmologic_constant = 1
    initial_day = DateTime.to_date(start_record_timestamp)
    end_day = DateTime.to_date(end_record_timestamp)

    days_of_call = Date.diff(end_day, initial_day)
    days_in_call = days_of_call + cosmologic_constant 

    call_with_how_much_days_duration = [%{days: days_in_call} | call]
    call_with_how_much_days_duration
  end

  defp calculate_accountable_minutes_for([%{days: 2}, _, _] = call), do: adjust_start_time_limit(call)
  defp calculate_accountable_minutes_for([%{days: 1}, _, _] = call) do
    call
    |> adjust_start_time_limit()
    |> adjust_end_time_limit()
    |> get_duration_in_seconds()
    |> get_only_accountable_call_minutes()
  end


  # Quando a ligação inicia e termina no mesmo dia então basta verificar 
  # a quantidade de minutos tarifados no próprio dia
  defp adjust_start_time_limit([%{days: 1} = days, %{timestamp: start_record_timestamp}, end_record]) do
    six_am = "06"
    new_possible_start_record_timestamp = generate(six_am, start_record_timestamp)

    DateTime.compare(start_record_timestamp, new_possible_start_record_timestamp)
    |> return_start_time_for_this(start_record_timestamp, new_possible_start_record_timestamp)
    |> mount_start_result(end_record, days)
  end

  # Como a ligação inicia-se em um dia e termina em outro é necessário verificar 
  # Quantos minutos foram tarifados para o dia inicial e para o dia final
  defp adjust_start_time_limit([%{days: 2} = days, %{timestamp: start_record_timestamp}, %{timestamp: end_record_timestamp}]) do
    IO.puts "Nada a ve"
    minutos_do_primeiro_dia = montar_call_com_start_record_e_10_pm_como_end_record(start_record_timestamp)
    |> calcular_minutos

    minutos_do_segundo_dia = montar_call_com_6_am_como_start_e_end_record_timestamp(end_record_timestamp)
    |> calcular_minutos

    minutos_do_primeiro_dia + minutos_do_segundo_dia
  end

  #Region montar_call_com_start_record_e_10_pm_como_end_record

  defp montar_call_com_start_record_e_10_pm_como_end_record(start_record_timestamp) do
    ten_pm = "22"
    end_record_of_start_day = generate(ten_pm, start_record_timestamp)
    days = %{days: 1}
    first_day = [days, %{timestamp: start_record_timestamp}, %{timestamp: end_record_of_start_day}]
    adjust_start_time_limit(first_day)
    |> IO.inspect
  end

  

  #EndRegion montar_call_com_start_record_e_10_pm_como_end_record


  #Region montar_call_com_6_am_como_start_e_end_record_timestamp

  defp montar_call_com_6_am_como_start_e_end_record_timestamp(end_record_timestamp) do
    six_am = "06"
    start_record_of_end_day = generate(six_am, end_record_timestamp)
    days = %{days: 1}
    last_day = [days, %{timestamp: start_record_of_end_day}, %{timestamp: end_record_timestamp}]
    adjust_start_time_limit(last_day)
  end

  #EndRegion montar_call_com_6_am_como_start_e_end_record_timestamp


  #Region calcular_minutos
  
  defp calcular_minutos([_days | call_records_timestamps ]) do
    call_records_timestamps
    |> get_duration_in_seconds()
    |> get_only_accountable_call_minutes()
  end

  #EndRegion calcular_minutos



  # Como esse cenário é de quantidade maior que 3 dias então
  # Calcula os minutos da data inicial e final e soma com as horas dos dias intermediários
  defp adjust_start_time_limit([days, %{timestamp: start_record_timestamp}, end_record]) do
    six_am = "06"
    new_possible_start_record_timestamp = generate(six_am, start_record_timestamp)

    DateTime.compare(start_record_timestamp, new_possible_start_record_timestamp)
    |> return_start_time_for_this(start_record_timestamp, new_possible_start_record_timestamp)
    |> mount_start_result(end_record, days)
  end

  defp adjust_end_time_limit([%{days: 1}, start_record, %{timestamp: end_record_timestamp}]) do
    ten_pm = "22"
    new_possible_end_record_timestamp = generate(ten_pm, end_record_timestamp) 

    DateTime.compare(end_record_timestamp, new_possible_end_record_timestamp)
    |> return_end_time_for_this(end_record_timestamp, new_possible_end_record_timestamp)
    |> mount_end_result(start_record)
  end

  defp adjust_end_time_limit([%{days: 2}, start_record, %{timestamp: end_record_timestamp}]) do
    ten_pm = "22"
    new_possible_end_record_timestamp = generate(ten_pm, end_record_timestamp) 

    DateTime.compare(end_record_timestamp, new_possible_end_record_timestamp)
    |> return_end_time_for_this(end_record_timestamp, new_possible_end_record_timestamp)
    |> mount_end_result(start_record)
  end

  # quantidade_dias * (14 * 60)

  defp adjust_end_time_limit([_dont_matter, start_record, %{timestamp: end_record_timestamp}]) do
    ten_pm = "22"
    new_possible_end_record_timestamp = generate(ten_pm, end_record_timestamp) 

    DateTime.compare(end_record_timestamp, new_possible_end_record_timestamp)
    |> return_end_time_for_this(end_record_timestamp, new_possible_end_record_timestamp)
    |> mount_end_result(start_record)
  end

  defp generate(hour, date) do
    date_as_iso = "#{BillDetailsFormatter.format(date, :date_y_m_d)}T#{hour}:00:00Z"
    {:ok, converted_date, 0} = DateTime.from_iso8601(date_as_iso)
    
    converted_date
  end

  defp get_duration_in_seconds([start_record, end_record]) do
    DateTime.diff(end_record.timestamp, start_record.timestamp) 
  end

  defp get_only_accountable_call_minutes(from_call_duration_in_seconds) when from_call_duration_in_seconds < 60, do: 0
  defp get_only_accountable_call_minutes(from_call_duration_in_seconds) do
    one_minute = 60
    Integer.floor_div(from_call_duration_in_seconds, one_minute)
  end

  defp return_start_time_for_this(:lt, _start_record_timestamp, six_am), do: six_am
  defp return_start_time_for_this(_equal_or_greater_result, start_record_timestamp, _six_am), do: start_record_timestamp
  
  defp return_end_time_for_this(:lt, end_record_timestamp, _ten_pm), do: end_record_timestamp
  defp return_end_time_for_this(_equal_or_greater_result, _end_record_timestamp, ten_pm), do: ten_pm

  defp mount_start_result(start_record_timestamp, end_record, days_in_call) do
    [days_in_call, %{timestamp: start_record_timestamp}, end_record]
  end

  defp mount_end_result(end_record_timestamp, start_record) do
    [start_record, %{timestamp: end_record_timestamp}]
  end

end