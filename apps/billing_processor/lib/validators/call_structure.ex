defmodule BillingProcessor.CallStructure do
  alias BillingProcessor.Error

  def validate_pair_of(call_records) do
    call_records
    |> Enum.group_by(fn call_record -> call_record["call_id"] end)
    |> Enum.flat_map(fn {_, call_records} -> process_validation_of(call_records) end)
  end

  defp process_validation_of(call_records) do
    call_records
    |> Enum.count
    |> mount_error_if_needed(call_records)
  end

  defp mount_error_if_needed(2, call_records), do: process_validation_type_of(call_records)
  defp mount_error_if_needed(_, call_records), do: mount_error(true, call_records)

  defp process_validation_type_of([first_call_record | [second_call_record]] = call_records) do
    first_call_record_has_valid_type = is_domain_type_valid?(first_call_record)
    second_call_record_has_valid_type = is_domain_type_valid?(second_call_record)
    domain_type_validation = {first_call_record_has_valid_type, second_call_record_has_valid_type}

    check_error(domain_type_validation, call_records)
  end

  defp is_domain_type_valid?(call_record), do: call_record["type"] in ["start", "end"]

  defp check_error({true, true}, [first_call_record | [second_call_record]] = call_records) do 
    first_call_record
    |> has_duplicated_type_with?(second_call_record)
    |> mount_error(call_records)
  end
  defp check_error(_domain_type_not_used, call_records), do: mount_error(true, call_records)

  defp has_duplicated_type_with?(first_call_record, second_call_record) do
    first_call_record["type"] == second_call_record["type"]
  end

  def mount_error(true, call_records) do
    call_records
    |> Enum.map(fn in_call_record -> Error.build(in_call_record, {:pair_dont_match, "call_id"}, true) end) 
  end
  def mount_error(false, call_records), do: call_records

end