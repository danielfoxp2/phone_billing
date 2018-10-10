defmodule BillingGatewayWeb.CallRecordView do
  use BillingGatewayWeb, :view
  alias BillingGatewayWeb.CallRecordView

  def render("index.json", %{call_records: call_records}) do
    %{data: render_many(call_records, CallRecordView, "call_record.json")}
  end

  def render("show.json", %{protocol_number: protocol_number}) do
    %{protocol_number: protocol_number}
  end

  def render("call_record.json", %{call_record: call_record}) do
    %{
      id: call_record.id,
      type: call_record.type,
      timestamp: call_record.timestamp,
      call_id: call_record.call_id,
      source: call_record.source,
      destination: call_record.destination}
  end
end
