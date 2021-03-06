defmodule BillingRepository.Bills.TariffRepository do
  alias BillingRepository.Repo

  @moduledoc """
  Responsible for manage the persistence of taxes that will be used in bill calculation
  """


  @doc """
  Gets the persisted standing and call charges for the given reference period.

  ## Parameters

    - reference_period: A map having a key called "reference_period" and a value in the format `"MM/yyyy"`.

  ## Examples

      iex> TariffRepository.get_taxes(%{"reference_period" => "02/2019"})
      %{ reference_period: "02/2019", standing_charge: 0.36, call_charge: 0.09 }

      iex> TariffRepository.get_taxes(%{"reference_period" => "05/2019"})
      %{ reference_period: "05/2019", standing_charge: 0.50, call_charge: 0.17 }
  """
  def get_taxes(%{"reference_period" => reference_period}) do
    reference_period
    |> format_for_db()
    |> get_query()
    |> Repo.query!()
    |> mount_result()
  end

  @doc """
  Insert for the immediate next reference the same taxes of the given reference if there isn't any configured taxes already persisted.
  
  ## Parameters

    - reference_period: A String in the format `"MM/yyyy"`.

  ## Examples

      iex> TariffRepository.insert_taxes_if_needed_for("02/2019")
      {:ok, %{rows: nil, num_rows: 1}}
  """
  def insert_taxes_if_needed_for(reference_period) do
    reference_period
    |> get_next()
    |> get_insert_taxes_query()
    |> Repo.query!()
  end

  @doc """
  Insert taxes for the given reference.
  
  ## Parameters

    A map with the following structure:

    - reference_period: A String in the format `"MM/yyyy"`.
    - standing_charge: A float number.
    - call_charge: A float number.

  ## Examples

      iex> taxes = %{ "reference_period" => "05/2019", "standing_charge" => 0.50, "call_charge" => 0.17 }
      iex> TariffRepository.insert_new(taxes)
      {:ok, "Taxes inserted"}
  """
  def insert_new(taxes) do
    taxes
    |> delete_reference_if_exists()
    |> insert_new_taxes()
    |> mount_response()
  end

  defp format_for_db(reference_period) do
    [month, year] = String.split(reference_period, "/")

    "#{year}#{month}"
  end

  defp get_query(reference_period) do
    """
      select reference, standing_charge, call_charge
      from tariffs
      where reference = #{reference_period}
    """
  end

  defp mount_result(%Postgrex.Result{rows: rows}) do
    rows 
    |> Enum.flat_map(fn elemento -> elemento end)
    |> mount_taxes()
  end

  defp mount_response({:ok, _}), do: {:ok, "Taxes inserted"}
  defp mount_response(result), do: result  

  defp mount_taxes([]), do: %{}
  defp mount_taxes([reference_period, standing_charge, call_charge]) do 
    %{
      reference_period: reference_period,
      standing_charge: standing_charge,
      call_charge: call_charge
    }
  end

  defp get_next(reference_period) do
    [month, year] = String.split(reference_period, "/")
    {parsed_month, _} = Integer.parse(month)
    {parsed_year, _} = Integer.parse(year)

    {:ok, first_day_of_month} = Date.new(parsed_year, parsed_month, 1)
    next_reference = Date.add(first_day_of_month, 31)
    formatted_month = String.pad_leading("#{next_reference.month}", 2, "0")

    "#{next_reference.year}#{formatted_month}"
  end

  defp get_insert_taxes_query(reference_period) do
    """
      insert into tariffs (reference, standing_charge, call_charge)
      select #{reference_period}, standing_charge, call_charge from tariffs t1 
      where reference = (select max(reference) 
                from tariffs t2 where reference < #{reference_period}) 
      and not exists (select 1 from tariffs where reference = #{reference_period})
    """
  end

  defp delete_reference_if_exists(taxes) do
    reference_as_integer = format_for_db(taxes["reference_period"])
    Repo.query("delete from tariffs where reference = #{reference_as_integer}")

    taxes
  end

  defp insert_new_taxes(taxes) do
    taxes
    |> get_insert_new_taxes_query()
    |> Repo.query()
  end

  defp get_insert_new_taxes_query(taxes) do
    formatted_refence_period = format_for_db(taxes["reference_period"])

    """
      insert into tariffs (reference, standing_charge, call_charge)
      values (#{formatted_refence_period}, #{taxes["standing_charge"]}, #{taxes["call_charge"]})
    """
  end

end