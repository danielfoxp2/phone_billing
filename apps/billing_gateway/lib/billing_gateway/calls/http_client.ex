defmodule BillingGateway.HttpClient do
  
  def post(postback_url, call_records_process_result_as_json, headers) do
    HTTPoison.post(postback_url, call_records_process_result_as_json, headers)
  end

end