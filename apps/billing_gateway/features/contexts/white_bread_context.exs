defmodule WhiteBreadContext do
  use WhiteBread.Context

  import_steps_from BillingGateway.CallDetailContext
end
