defmodule BillingGatewayWeb.CallRecordController do
  use BillingGatewayWeb, :controller

  alias BillingGateway.Calls
  alias BillingRepository.Calls.CallRecord

  action_fallback BillingGatewayWeb.FallbackController

  def index(conn, _params) do
    #call_records = Calls.list_call_records()
    call_records = [%{
          id: 1,
          call_id: 1,
          destination: "+5562984680648",
          source: "+5562984680648",
          timestamp: "20181004235619",
          type: 1
    }]

    render(conn, "index.json", call_records: call_records)
  end

  def create(conn, %{"call_record" => call_record_params}) do
    with {:ok, %CallRecord{} = call_record} <- Calls.create_call_record(call_record_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", call_record_path(conn, :show, call_record))
      |> render("show.json", call_record: call_record)
    end
  end

  def show(conn, %{"id" => id}) do
    call_record = Calls.get_call_record!(id)
    render(conn, "show.json", call_record: call_record)
  end

  def update(conn, %{"id" => id, "call_record" => call_record_params}) do
    call_record = Calls.get_call_record!(id)

    with {:ok, %CallRecord{} = call_record} <- Calls.update_call_record(call_record, call_record_params) do
      render(conn, "show.json", call_record: call_record)
    end
  end

  def delete(conn, %{"id" => id}) do
    call_record = Calls.get_call_record!(id)
    with {:ok, %CallRecord{}} <- Calls.delete_call_record(call_record) do
      send_resp(conn, :no_content, "")
    end
  end
end
