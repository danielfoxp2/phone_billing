defmodule BillingProcessor.CallRecordsProcessorTest do
  use ExUnit.Case
  alias BillingProcessor.CallRecordsProcessor

  describe "call records processor filtering" do
    test "should return only call records without errors" do
      call_records_with_some_errors = [%{"id" => 1, "errors" => "error_message"}, %{"id" => 2, "errors" => "error_message"}, %{"id" => 3}]
      
      expected_call_records = [%{"id" => 3}]

      call_record_without_errors = CallRecordsProcessor.get_only_valid(call_records_with_some_errors)

      assert expected_call_records == call_record_without_errors
    end
  end

  describe "call records processing" do
    test "should present the quantity of received records" do
      call_records = [create_start_call_detail_record(), create_end_call_detail_record()]
      %{received_records: received_records} = CallRecordsProcessor.execute(call_records)

      assert received_records == 2
    end

    test "should present the quantity of consistent records as success" do
      call_records = [create_start_call_detail_record(), create_end_call_detail_record()]
      %{consistent_records: consistent_records} = CallRecordsProcessor.execute(call_records)

      assert consistent_records == 2
    end

    test "should present the quantity of inconsistent records as errors" do
      call_records = [create_start_call_detail_inconsistent_record(), create_end_call_detail_record()]
      %{inconsistent_records: inconsistent_records} = CallRecordsProcessor.execute(call_records)

      assert inconsistent_records == 2
    end
  end

  defp create_start_call_detail_record() do
    %{
      "id" => 1,
      "type" => "start",
      "timestamp" => "",
      "call_id" => 123,
      "source" => 62984680648,
      "destination" => 62111222333
    }
  end

  defp create_end_call_detail_record() do
    %{
      "id" => 2,
      "type" => "end",
      "timestamp" => "",
      "call_id" => 123
    }
  end

  defp create_start_call_detail_inconsistent_record() do
    %{
      "id" => 1,
      "type" => "start",
      "timestamp" => "",
      "call_id" => 123,
      "source" => "",
      "destination" => 62111222333
    }
  end
end

# Recebidos :0 --numero de registros
# Sucesso :0 --quantidade de registros salvos
# Erros :0 --quantidade de registros recusados (inconsistentes)
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