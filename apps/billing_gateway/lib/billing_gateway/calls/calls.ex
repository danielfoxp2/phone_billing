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
  alias BillingProcessor.CallRecordsProcessor

  @doc """
  Returns the list of call_records.

  ## Examples

      iex> list_call_records()
      [%CallRecord{}, ...]

  """
  def list_call_records do
    Repo.all(CallRecord)
  end

  @doc """
  Gets a single call_record.

  Raises `Ecto.NoResultsError` if the Call record does not exist.

  ## Examples

      iex> get_call_record!(123)
      %CallRecord{}

      iex> get_call_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_call_record!(id), do: Repo.get!(CallRecord, id)

  @doc """
  Creates a call_record.

  ## Examples

      iex> create_call_record(%{field: value})
      {:ok, %CallRecord{}}

      iex> create_call_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_call_record(call_records_params) do
    get_postback_url_from(call_records_params)
    |> PostbackUrlValidator.is_valid?
    |> process_call_records(call_records_params)
  end

  defp get_postback_url_from(%{"postback_url" => postback_url}), do: postback_url
  defp get_postback_url_from(_call_records_params), do: nil

  defp process_call_records({:postback_url_error, _} = processing_cant_proceed, _call_records_params), do: processing_cant_proceed
  defp process_call_records({:ok, _}, call_records_params) do
    Task.start(fn -> process(call_records_params) end)
    {:ok, get_protocol_number()}
  end

  defp process(%{"call_records" => call_records} = call_records_params) do
    IO.puts " rodou process validate"

    call_records
    |> CallRecordContentValidator.validate()
    |> DuplicationValidator.add_errors_for_duplicated()
    |> DatabaseDuplication.search_for()
    |> DuplicationValidator.add_errors_for_duplicated_in_database()
    |> CallStructure.validate_pair_of()
    |> CallRecordsProcessor.get_only_valid()
    |> CallRecordRepository.insert_only_valid()
    |> CallRecordsProcessor.mount_processing_result()
  end
  
  defp get_protocol_number(), do: Protocol.new_number
  @doc """
  Updates a call_record.

  ## Examples

      iex> update_call_record(call_record, %{field: new_value})
      {:ok, %CallRecord{}}

      iex> update_call_record(call_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_call_record(%CallRecord{} = call_record, attrs) do
    call_record
    |> CallRecord.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CallRecord.

  ## Examples

      iex> delete_call_record(call_record)
      {:ok, %CallRecord{}}

      iex> delete_call_record(call_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_call_record(%CallRecord{} = call_record) do
    Repo.delete(call_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking call_record changes.

  ## Examples

      iex> change_call_record(call_record)
      %Ecto.Changeset{source: %CallRecord{}}

  """
  def change_call_record(%CallRecord{} = call_record) do
    CallRecord.changeset(call_record, %{})
  end
end
