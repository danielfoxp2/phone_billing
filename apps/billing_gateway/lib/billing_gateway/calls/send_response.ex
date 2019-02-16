defmodule BillingGateway.SendResponse do

  @http_client Application.get_env(:billing_gateway, :http_client)
  
  @moduledoc """
    Mount json data with processed call records to be sent to postback url
  """

  @doc """
  Mount json data with processed call records to be sent to postback url

  """
  def to(call_records_process_result, postback_url) do
    headers = ["content-type": "application/json"]
    @http_client.post(postback_url, get_json_from(call_records_process_result), headers)
  end

  defp get_json_from(call_records_process_result) do
    {:ok, call_records_as_json} = call_records_process_result |> Poison.encode 
    call_records_as_json
  end
end