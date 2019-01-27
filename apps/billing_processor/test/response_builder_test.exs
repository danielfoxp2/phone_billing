defmodule BillingProcessor.ResponseBuilderTest do
  use ExUnit.Case
  alias BillingProcessor.ResponseBuilder

  describe "call records processing" do
    test "should present the quantity of received records" do
      calls_inserted = []
      call_records = {calls_inserted, [create_start_call_detail_record(), create_end_call_detail_record()]}
      %{received_records_quantity: received_records_quantity} = ResponseBuilder.mount_processing_result(call_records)

      assert received_records_quantity == 2
    end

    test "should present the quantity of consistent records as success" do
      calls_inserted = [{:ok, %{}}, {:error, %{start_call: %{__struct__: :start_call}, end_call: %{__struct__: :end_call}}}]
      call_records = {calls_inserted, [create_start_call_detail_record(), create_end_call_detail_record(), create_start_call_detail_record(), create_end_call_detail_record()]}
      %{consistent_records_quantity: consistent_records_quantity} = ResponseBuilder.mount_processing_result(call_records)
      number_of_call_records_in_a_consistent_call = 2

      assert consistent_records_quantity == number_of_call_records_in_a_consistent_call
    end

    test "should present zero success when there are no consistent records" do
      calls_inserted = []
      call_records = {calls_inserted, [create_start_call_detail_inconsistent_record(), create_end_call_detail_inconsistent_record()]}
      %{consistent_records_quantity: consistent_records_quantity} = ResponseBuilder.mount_processing_result(call_records)

      assert consistent_records_quantity == 0
    end

    test "should present zero database inconsistent records quantity when there are no consistent records" do
      calls_inserted = []
      call_records = {calls_inserted, [create_start_call_detail_inconsistent_record(), create_end_call_detail_inconsistent_record()]}
      %{database_inconsistent_records_quantity: database_inconsistent_records_quantity} = ResponseBuilder.mount_processing_result(call_records)

      assert database_inconsistent_records_quantity == 0
    end

    test "should present zero failed records on insert when there are no consistent records" do
      calls_inserted = []
      call_records = {calls_inserted, [create_start_call_detail_inconsistent_record(), create_end_call_detail_inconsistent_record()]}
      %{failed_records_on_insert: failed_records_on_insert} = ResponseBuilder.mount_processing_result(call_records)

      assert failed_records_on_insert == []
    end

    test "should present the quantity of inconsistent records as validation errors" do
      calls_inserted = []
      call_records = {calls_inserted, [create_start_call_detail_inconsistent_record(), create_end_call_detail_inconsistent_record()]}
      %{inconsistent_records_quantity: inconsistent_records_quantity} = ResponseBuilder.mount_processing_result(call_records)

      assert inconsistent_records_quantity == 2
    end

    test "should present the quantity of database inconsistent records as database errors" do
      calls_inserted_with_errors = [{:error, %{start_call: %{__struct__: :start_call}, end_call: %{__struct__: :end_call}}}, {:ok, %{}}]
      call_records = {calls_inserted_with_errors, [create_start_call_detail_record(), create_end_call_detail_record(), create_start_call_detail_record(), create_end_call_detail_record()]}
      %{database_inconsistent_records_quantity: database_inconsistent_records_quantity} = ResponseBuilder.mount_processing_result(call_records)

      assert database_inconsistent_records_quantity == 2
    end

    test "should present the call records with validation errors" do
      calls_inserted = []
      call_records = {calls_inserted, [create_start_call_detail_record(), create_end_call_detail_inconsistent_record()]}
      expected_result = [create_end_call_detail_inconsistent_record()]
      %{failed_records_on_validation: failed_records_on_validation} = ResponseBuilder.mount_processing_result(call_records)

      assert failed_records_on_validation == expected_result
    end

    test "should present the call records with insertion database errors" do
      calls_inserted_with_errors = [{:error, %{start_call: %{__struct__: :start_call, id: "1"}, end_call: %{__struct__: :end_call, id: "2"}}}, {:ok, %{}}]
      call_records = {calls_inserted_with_errors, [create_start_call_detail_record(), create_end_call_detail_record(), create_start_call_detail_record(), create_end_call_detail_record()]}
      expected_result = [%{id: "1"}, %{id: "2"}]
      %{failed_records_on_insert: failed_records_on_insert} = ResponseBuilder.mount_processing_result(call_records)

      assert failed_records_on_insert == expected_result
    end

  end

  defp create_start_call_detail_record() do
    {:ok,
      %{
        "id" => 1,
        "type" => "start",
        "timestamp" => "",
        "call_id" => "123",
        "source" => "62984680648",
        "destination" => "62111222333"
      }
    }
  end

  defp create_end_call_detail_record() do
    {:ok,
      %{
        "id" => "2",
        "type" => "end",
        "timestamp" => "",
        "call_id" => "123"
      }
    }
  end

  defp create_start_call_detail_inconsistent_record() do
    %{
      "id" => "1",
      "type" => "start",
      "timestamp" => "",
      "call_id" => "123",
      "source" => "",
      "destination" => "62111222333",
      "errors" => []
    }
  end

  defp create_end_call_detail_inconsistent_record() do
    %{
      "id" => "2",
      "type" => "end",
      "timestamp" => "",
      "call_id" => "123",
      "errors" => []
    }
  end

end