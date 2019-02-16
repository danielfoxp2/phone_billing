defmodule BillingGateway.HttpClient do
  @moduledoc """
    Sends result of call records processed to the postback url  
  """

  @doc """
  Sends result of call records processed to the postback url

  """
  def post(postback_url, call_records_process_result_as_json, headers) do
    HTTPoison.post(postback_url, call_records_process_result_as_json, headers)
  end

end