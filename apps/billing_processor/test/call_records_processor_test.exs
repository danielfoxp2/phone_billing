defmodule BillingProcessor.CallRecordsProcessorTest do
  use ExUnit.Case
  alias BillingProcessor.CallRecordsProcessor

  describe "call records processing" do
    test "should present the quantity of received records" do
      call_records = [create_start_call_detail_record(), create_end_call_detail_record()]
      %{received_records: received_records} = CallRecordsProcessor.execute(call_records)

      assert received_records == 2
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
end

# Recebidos :0 --numero de registros
# Processados :0 --numero de registros processados
# Sucesso :0 --quantidade de registros salvos
# Erros :0 --quantidade de registros recusados (inconsistentes)
# inconsistent_records: [%{
#       "id" => 1,
#       "type" => "start",
#       "timestamp" => "",
#       "call_id" => 123,
#       "source" => 62984680648,
#       "destination" => 62111222333,
#       "errors" => []
#     }
#]