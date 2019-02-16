defmodule BillingGateway.Dummy.HttpClient do
  @moduledoc false
  
  def post(_postback_url, call_records_process_result, _headers) do
    call_records_process_result
    |> Poison.decode
    |> get_agent_name()
    |> create_agent_if_need()  
  end

  defp get_agent_name({_, from_call_records_process_result}) do
    agent_name = get_name(from_call_records_process_result)

    {agent_name, from_call_records_process_result}
  end

  defp create_agent_if_need({:no_name, _call_records_process_result}), do: :nothing
  defp create_agent_if_need({with_this_name, call_records_process_result}) do
    Agent.start_link(fn -> call_records_process_result end, name: with_this_name)
  end

  defp get_name(from_call_records_process_result) do
    from_call_records_process_result["failed_records_on_validation"]
    |> List.first 
    |> get_name_if_exists
    |> String.to_atom
  end

  defp get_name_if_exists(nil), do: "no_name"
  defp get_name_if_exists(from_map) do
    Map.get(from_map, "dummy_postback_url_agent")
  end
end