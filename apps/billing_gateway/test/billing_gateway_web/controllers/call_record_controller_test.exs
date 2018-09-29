defmodule BillingGatewayWeb.CallRecordControllerTest do
  use BillingGatewayWeb.ConnCase

  alias BillingGateway.Calls
  alias BillingGateway.Calls.CallRecord

  @create_attrs %{call_id: 42, destination: "some destination", id: 42, source: "some source", timestamp: "some timestamp", type: "some type"}
  @update_attrs %{call_id: 43, destination: "some updated destination", id: 43, source: "some updated source", timestamp: "some updated timestamp", type: "some updated type"}
  @invalid_attrs %{call_id: nil, destination: nil, id: nil, source: nil, timestamp: nil, type: nil}

  def fixture(:call_record) do
    {:ok, call_record} = Calls.create_call_record(@create_attrs)
    call_record
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all call_records", %{conn: conn} do
      conn = get conn, call_record_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create call_record" do
    test "renders call_record when data is valid", %{conn: conn} do
      conn = post conn, call_record_path(conn, :create), call_record: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, call_record_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "call_id" => 42,
        "destination" => "some destination",
        "id" => 42,
        "source" => "some source",
        "timestamp" => "some timestamp",
        "type" => "some type"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, call_record_path(conn, :create), call_record: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update call_record" do
    setup [:create_call_record]

    test "renders call_record when data is valid", %{conn: conn, call_record: %CallRecord{id: id} = call_record} do
      conn = put conn, call_record_path(conn, :update, call_record), call_record: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, call_record_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "call_id" => 43,
        "destination" => "some updated destination",
        "id" => 43,
        "source" => "some updated source",
        "timestamp" => "some updated timestamp",
        "type" => "some updated type"}
    end

    test "renders errors when data is invalid", %{conn: conn, call_record: call_record} do
      conn = put conn, call_record_path(conn, :update, call_record), call_record: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete call_record" do
    setup [:create_call_record]

    test "deletes chosen call_record", %{conn: conn, call_record: call_record} do
      conn = delete conn, call_record_path(conn, :delete, call_record)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, call_record_path(conn, :show, call_record)
      end
    end
  end

  defp create_call_record(_) do
    call_record = fixture(:call_record)
    {:ok, call_record: call_record}
  end
end
