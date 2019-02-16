defmodule BillingGatewayWeb.CallRecordController do
  use BillingGatewayWeb, :controller

  alias BillingGateway.Calls

  action_fallback BillingGatewayWeb.FallbackController

  @moduledoc """
    Represent the entry point of call records insertion API
  """

  @doc """
    Represent the entry point of call records insertion API
  """

  def create(conn, %{"call_records_params" => call_records_params}) do
    with {:ok, protocol_number} <- Calls.create_call_record(call_records_params) do
      conn
      |> render("show.json", protocol_number: protocol_number)
    end
  end
end
