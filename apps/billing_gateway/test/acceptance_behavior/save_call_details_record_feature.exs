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
      minimum_expected_protocol = 1

      assert json_response(conn, 200)["protocol_number"] >= minimum_expected_protocol
    end

    test "send to postback url data status of processed call records", %{conn: conn} do
      params = %{call_records: create_consistent_call(20, 25) ++ create_inconsistent_call(30, 29), postback_url: "www.example.com"}
     
      post(conn, call_record_path(conn, :create), call_records_params: params)
      Process.sleep(2000)

     call_records_process_result = Agent.get(:dummy_postback_url_agent, fn content -> content end)
      
      expected_result = expected_call_records_process_result()

      assert call_records_process_result == expected_result
    end
    
  end

  defp create_start_call_detail_record() do
    %{
      "id" => "11",
      "type" => "start",
      "timestamp" => "2018-11-15T13:15:44Z",
      "call_id" => "123",
      "source" => "62984680648",
      "destination" => "62111222333"
    }
  end

  defp create_end_call_detail_record() do
    %{
      "id" => "10",
      "type" => "end",
      "timestamp" => "2018-11-15T13:23:14Z",
      "call_id" => "123"
    }
  end

  defp create_inconsistent_call(id, call_id) do
    [%{
      "dummy_postback_url_agent" => "dummy_postback_url_agent",
      "id" => "#{id}",
      "type" => "start",
      "timestamp" => "2018-11-15T13:20:14Z",
      "call_id" => "#{call_id}",
      "source" => "62984680648",
      "destination" => "62111222333"
    },

    %{
      "dummy_postback_url_agent" => "dummy_postback_url_agent",
      "id" => "#{id}",
      "type" => "end",
      "timestamp" => "2018-11-15T13:23:14Z",
      "call_id" => "#{call_id}"
    }
    ]
  end

  defp create_consistent_call(id, call_id) do
    [
      %{
      "id" => "#{id}",
      "type" => "start",
      "timestamp" => "2018-11-15T13:15:44Z",
      "call_id" => "#{call_id}",
      "source" => "62984680648",
      "destination" => "62111222333"
      },
      %{
        "id" => "#{id + 1}",
        "type" => "end",
        "timestamp" => "2018-11-15T13:23:14Z",
        "call_id" => "#{call_id}"
      }
    ]
  end

  defp expected_call_records_process_result() do
    %{
	    "received_records_quantity" => 4,
	    "consistent_records_quantity" => 2,
	    "inconsistent_records_quantity" => 2,
	    "database_inconsistent_records_quantity" => 0,
	    "failed_records_on_validation" => create_inconsistent_call_with_errors(),
	    "failed_records_on_insert" => []
    }
  end

  defp create_inconsistent_call_with_errors() do
    [
      %{
        "dummy_postback_url_agent" => "dummy_postback_url_agent",
        "id" => "30",
        "type" => "start",
        "timestamp" => "2018-11-15T13:20:14Z",
        "call_id" => "29",
        "source" => "62984680648",
        "destination" => "62111222333",
        "errors" => ["call record with id: 30 is duplicated in call records being inserted"]
      },
    
      %{
        "dummy_postback_url_agent" => "dummy_postback_url_agent",
        "id" => "30",
        "type" => "end",
        "timestamp" => "2018-11-15T13:23:14Z",
        "call_id" => "29",
        "errors" => ["call record with id: 30 is duplicated in call records being inserted"]
      }
    ]
  end

  
end