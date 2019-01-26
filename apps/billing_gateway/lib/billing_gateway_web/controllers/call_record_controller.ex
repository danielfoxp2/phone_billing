defmodule BillingGatewayWeb.CallRecordController do
  use BillingGatewayWeb, :controller

  alias BillingGateway.Calls
  alias BillingRepository.Calls.CallRecord

  action_fallback BillingGatewayWeb.FallbackController

  def create(conn, %{"call_records_params" => call_records_params}) do
    with {:ok, protocol_number} <- Calls.create_call_record(call_records_params) do
      conn
      |> render("show.json", protocol_number: protocol_number)
    end
  end
end
