defmodule BillingProcessor.CallRecordsProcessorTest do
  use ExUnit.Case
  alias BillingProcessor.CallRecordsProcessor

  describe "call records processor filtering" do
    test "should return only call records without errors" do
      call_records_with_some_errors = mount_call_records_with_some_errors()
      
      expected_grouped_calls = %{"1" => [%{"id" => "3", "call_id" => "1", "type" => "start"}, %{"id" => "4", "call_id" => "1", "type" => "end"}]}
      expected_call_records = {expected_grouped_calls, call_records_with_some_errors}

      actual_call_record_without_errors = CallRecordsProcessor.get_only_valid(call_records_with_some_errors)

      assert actual_call_record_without_errors == expected_call_records
    end
  end

  describe "call records processing" do
    test "should present the quantity of received records" do
      call_records_inserted = []
      call_records = {call_records_inserted, [create_start_call_detail_record(), create_end_call_detail_record()]}
      %{received_records: received_records} = CallRecordsProcessor.execute(call_records)

      assert received_records == 2
    end

    test "should present the quantity of consistent records as success" do
      call_records_inserted = [{:ok, %{}}, {:ok, %{}}, {:error, %{}}]
      call_records = {call_records_inserted, [create_start_call_detail_record(), create_end_call_detail_record()]}
      %{consistent_records: consistent_records} = CallRecordsProcessor.execute(call_records)

      assert consistent_records == 2
    end

    test "should present the quantity of inconsistent records as validation errors" do
      call_records_inserted = []
      call_records = {call_records_inserted, [create_start_call_detail_inconsistent_record(), create_end_call_detail_inconsistent_record()]}
      %{inconsistent_records: inconsistent_records} = CallRecordsProcessor.execute(call_records)

      assert inconsistent_records == 2
    end

    test "should present the quantity of database inconsistent records as database errors" do
      call_records_inserted_with_errors = [{:error, %{}}, {:error, %{}}, {:ok, %{}}]
      call_records = {call_records_inserted_with_errors, [create_start_call_detail_record(), create_end_call_detail_record()]}
      %{database_inconsistent_records: database_inconsistent_records} = CallRecordsProcessor.execute(call_records)

      assert database_inconsistent_records == 2
    end

    test "should present the call records with validation errors" do
      call_records_inserted = []
      call_records = {call_records_inserted, [create_start_call_detail_record(), create_end_call_detail_inconsistent_record()]}
      expected_result = [create_end_call_detail_inconsistent_record()]
      %{inconsistent_validation_records: inconsistent_validation_records} = CallRecordsProcessor.execute(call_records)

      assert inconsistent_validation_records == expected_result
    end

    test "should present the call records with insertion database errors" do
      call_records_inserted_with_errors = [{:error, %{}}, {:error, %{}}, {:ok, %{}}]
      call_records = {call_records_inserted_with_errors, [create_start_call_detail_record(), create_end_call_detail_record()]}
      expected_result = [{:error, %{}}, {:error, %{}}]
      %{failed_records_on_insert: failed_records_on_insert} = CallRecordsProcessor.execute(call_records)

      assert failed_records_on_insert == expected_result
    end
  end

  defp create_start_call_detail_record() do
    %{
      "id" => 1,
      "type" => "start",
      "timestamp" => "",
      "call_id" => "123",
      "source" => "62984680648",
      "destination" => "62111222333"
    }
  end

  defp create_end_call_detail_record() do
    %{
      "id" => "2",
      "type" => "end",
      "timestamp" => "",
      "call_id" => "123"
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

  defp mount_call_records_with_some_errors() do
    [
      %{"id" => "1", "errors" => "error_message"}, 
      %{"id" => "2", "errors" => "error_message"}, 
      %{"id" => "3", "call_id" => "1", "type" => "start"}, 
      %{"id" => "4", "call_id" => "1", "type" => "end"}
    ]
  end
end

# Recebidos :0 --numero de registros
# Sucesso :0 --quantidade de registros salvos
# Erros de validação :0 --quantidade de registros recusados (inconsistentes)
# Erros ao inserir no banco: 0 (transacionar insert no banco pelo par de registros[call_id])
# inconsistent_records: [%{
#       "id" => 1,
#       "type" => "start",
#       "timestamp" => "",
#       "call_id" => 123,
#       "source" => 62984680648,
#       "destination" => 62111222333,
#       "errors" => ["asdf", "novo erro"]
#     }
#]
#