defmodule BillingRepository.Bills.TariffRepository do
  alias BillingRepository.Repo

  def get_taxes(reference_period) do
    reference_period
    |> get_query()
    |> Repo.query!()
    |> mount_result()
  end

  defp get_query(reference_period) do
    """
      select standing_charge, call_charge
      from tariffs
      where reference = #{reference_period}
    """
  end

  defp mount_result(%Postgrex.Result{rows: rows}) do
    rows 
    |> Enum.flat_map(fn elemento -> elemento end)
    |> mount_taxes()
  end

  defp mount_taxes([]), do: %{}
  defp mount_taxes([standing_charge, call_charge]) do 
    %{
      standing_charge: standing_charge,
      call_charge: call_charge
    }
  end

end