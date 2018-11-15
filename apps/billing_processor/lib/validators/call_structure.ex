defmodule BillingProcessor.CallStructure do
  alias BillingProcessor.Error

  def validate_pair_of(call_records) do
    call_records
    |> group_by_call_id()
    |> execute_validation_pipeline()
  end

  defp group_by_call_id(call_records), do: Enum.group_by(call_records, fn call_record -> call_record["call_id"] end)
  defp execute_validation_pipeline(call_records), do: Enum.flat_map(call_records, &process_validation_of/1)

  defp process_validation_of({nil, call_records}), do: call_records
  defp process_validation_of({"", call_records}), do: call_records
  defp process_validation_of({_, call_records}) do
    call_records
    |> get_quantity_of_the_same_call_id()
    |> mount_error_if_needed(call_records)
  end

  defp get_quantity_of_the_same_call_id(call_records), do: Enum.count(call_records)

  defp mount_error_if_needed(2, call_records), do: process_validation_type_of(call_records)
  defp mount_error_if_needed(_call_records_quantity, call_records), do: mount_error(true, call_records)

  defp process_validation_type_of([first_call_record | [second_call_record]] = of_call_records) do
    first_call_record_has_valid_type = is_domain_type_valid?(first_call_record)
    second_call_record_has_valid_type = is_domain_type_valid?(second_call_record)
    domain_type_validation = {first_call_record_has_valid_type, second_call_record_has_valid_type}

    check_call_for(domain_type_validation, of_call_records)
  end

  defp is_domain_type_valid?(call_record), do: call_record["type"] in ["start", "end"]

  defp check_call_for({true, true}, [first_call_record | [second_call_record]] = call_records) do 
    first_call_record
    |> has_duplicated_type_with?(second_call_record)
    |> mount_error(call_records)
  end
  defp check_call_for(_domain_type_not_used, call_records), do: mount_error(true, call_records)

  defp has_duplicated_type_with?(first_call_record, second_call_record) do
    first_call_record["type"] == second_call_record["type"]
  end

  def mount_error(false, call_records), do: call_records
  def mount_error(true, call_records) do
    call_records
    |> include_error_of_not_valid_pair()
  end

  defp include_error_of_not_valid_pair(for_this_call_records) do
    Enum.map(for_this_call_records, fn in_call_record -> 
      Error.build(in_call_record, {:pair_is_not_valid, "call_id"}, true) 
    end) 
  end

end