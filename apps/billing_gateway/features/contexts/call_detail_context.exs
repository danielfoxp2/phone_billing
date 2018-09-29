defmodule BillingGateway.CallDetailContext do
  use WhiteBread.Context
  
  given_ ~r/^that postback url not exists in the request parameters$/, fn state ->
    {:ok, state}
  end

  given_ ~r/^that postback url is invalid $/, fn state ->
    {:ok, state}
  end

  when_ ~r/^I try to process call details records$/, fn state ->
    {:ok, state}
  end

  then_ ~r/^the processing is not executed$/, fn state ->
    {:ok, state}
  end

  and_ ~r/^the message "(?<argument_one>[^"]+)" is immediately returned$/, fn state, %{argument_one: _argument_one} ->
    {:ok, state}
  end

  

  

end