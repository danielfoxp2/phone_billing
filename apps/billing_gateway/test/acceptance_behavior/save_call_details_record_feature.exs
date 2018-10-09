defmodule BillingGatewayWeb.SaveCallDetailsRecordFeature do
  use BillingGatewayWeb.ConnCase

  describe "Save call details records" do
    test "It does not process if there's no postback url", %{conn: conn} do

      params = %{call_records: %{}}
      conn = post(conn, call_record_path(conn, :create), call_record_params: params)
      expected_message = "The processing was not executed because postback url was not informed"

      assert json_response(conn, 200)["postback_url_error"] == expected_message
    end
    
  end
end