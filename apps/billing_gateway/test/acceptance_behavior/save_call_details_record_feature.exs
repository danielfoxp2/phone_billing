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
      params = %{call_records: [create_start_call_detail_record(), create_end_call_detail_record()], postback_url: "www.example.com"}
      conn = post(conn, call_record_path(conn, :create), call_records_params: params)
      expected_protocol = 1

      assert json_response(conn, 200)["protocol_number"] == expected_protocol
    end
    
  end

  defp create_valid_call_detail_params() do
    %{
      call_records: [create_start_call_detail_record(), create_end_call_detail_record()], 
      postback_url: ""
    }
  end

  defp create_start_call_detail_record() do
    %{
      "id" => "21",
      "type" => "start",
      "timestamp" => "2018-11-15T13:15:44Z",
      "call_id" => "123",
      "source" => "62984680648",
      "destination" => "62111222333"
    }
  end

  defp create_end_call_detail_record() do
    %{
      "id" => "20",
      "type" => "end",
      "timestamp" => "2018-11-15T13:23:14Z",
      "call_id" => "123"
    }
  end
end