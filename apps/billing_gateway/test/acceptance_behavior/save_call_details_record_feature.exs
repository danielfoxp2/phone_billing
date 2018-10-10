defmodule BillingGatewayWeb.SaveCallDetailsRecordFeature do
  use BillingGatewayWeb.ConnCase

  describe "Save call details records" do
    test "It does not process if there's no postback url", %{conn: conn} do
      params = %{call_records: []}
      conn = post(conn, call_record_path(conn, :create), call_records_params: params)
      expected_message = "The processing was not executed because postback url was not informed"

      assert json_response(conn, 200)["postback_url_error"] == expected_message
    end

    test "When there's postback url then a processing protocol is returned to the caller", %{conn: conn} do
      params = %{call_records: [], postback_url: "www.example.com"}
      conn = post(conn, call_record_path(conn, :create), call_records_params: params)
      expected_protocol = 9

      assert json_response(conn, 200)["protocol_number"] == expected_protocol
    end
    
  end
end