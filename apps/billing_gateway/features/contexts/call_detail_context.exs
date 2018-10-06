defmodule BillingGateway.CallDetailContext do
  use WhiteBread.Context

  Code.require_file("features/config/helper.exs")
  alias BillingGatewayWeb.Helper

  given_ ~r/^that postback url not exists in the request parameters$/, fn state ->
    state = %{call_records: %{}}
    {:ok, state}
  end

  given_ ~r/^that postback url is invalid $/, fn state ->
    {:ok, state}
  end

  when_ ~r/^I try to process call details records$/, fn state ->
    Helper.launch_api()
    state = HTTPoison.get("http://localhost:4000/api/call_records")
    {:ok, state}
  end

  then_ ~r/^the processing is not executed$/, fn state ->
    {:ok, state}
  end

  and_ ~r/^the message "(?<argument_one>[^"]+)" is immediately returned$/, fn state, %{argument_one: _argument_one} ->
    {:ok, %HTTPoison.Response{body: body, status_code: status_code}} = state

    assert status_code == 200
  end

  

  

end