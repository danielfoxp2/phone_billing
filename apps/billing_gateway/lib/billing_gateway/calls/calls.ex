defmodule BillingGateway.Calls do
  @moduledoc """
  The Calls context.
  """

  alias BillingRepository.Repo
  alias BillingRepository.Protocol
  alias BillingRepository.Calls.CallRecord
  alias BillingRepository.DatabaseDuplication
  alias BillingRepository.CallRecordRepository
  alias BillingProcessor.PostbackUrlValidator
  alias BillingProcessor.CallRecordContentValidator
  alias BillingProcessor.DuplicationValidator
  alias BillingProcessor.CallStructure
  alias BillingProcessor.ResponseBuilder
  alias BillingGateway.SendResponse

  def create_call_record(call_records_params) do
    get_postback_url_from(call_records_params)
    |> PostbackUrlValidator.is_valid?
    |> process_call_records(call_records_params)
  end

  defp get_postback_url_from(%{"postback_url" => postback_url}), do: postback_url
  defp get_postback_url_from(_call_records_params), do: nil

  defp process_call_records({:postback_url_error, _} = processing_cant_proceed, _call_records_params), do: processing_cant_proceed
  defp process_call_records({:ok, postback_url}, call_records_params) do
    Task.start(fn -> process(call_records_params, postback_url) end)
    {:ok, get_protocol_number()}
  end

  defp process(%{"call_records" => call_records} = call_records_params, postback_url) do
    call_records
    |> CallRecordContentValidator.validate()
    |> DuplicationValidator.add_errors_for_duplicated()
    |> DatabaseDuplication.search_for()
    |> DuplicationValidator.add_errors_for_duplicated_in_database()
    |> CallStructure.validate_pair_of()
    |> CallStructure.get_only_valid()
    |> CallRecordRepository.insert_only_valid()
    |> ResponseBuilder.mount_processing_result()
    |> SendResponse.to(postback_url)
  end
  
  defp get_protocol_number(), do: Protocol.new_number
  
end
