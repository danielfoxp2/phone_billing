defmodule BillingGatewayWeb.DummyPostbackUrlController do
  use BillingGatewayWeb, :controller

  def create(conn, dummy_postback_url_params) do
    Agent.start_link(fn -> dummy_postback_url_params end, name: :dummy_postback_url_agent)

    conn
    |> render("show.json", status: :ok)
  end

  def show(conn, params) do
    call_records_process_result = Agent.get(:dummy_postback_url_agent, fn content -> content end)

    conn
    |> render("show.json", call_records_process_result: call_records_process_result)
  end

end