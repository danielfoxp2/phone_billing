defmodule BillingGatewayWeb.Helper do

  def launch_api() do
    IO.puts "rodou feature_starting_state"
    endpoint_config =
    Application.get_env(:billing_gateway, BillingGatewayWeb.Endpoint)
    |> Keyword.put(:server, true)

    :ok = Application.put_env(:billing_gateway, BillingGatewayWeb.Endpoint, endpoint_config)

    # restart our application with serving enabled
    :ok = Application.stop(:billing_gateway)
    :ok = Application.start(:billing_gateway)
  end
  
end