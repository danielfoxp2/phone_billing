defmodule BillingProcessor.CallRecordValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.CallRecordValidator

  describe "call record validation" do
    test "should invalidate when it does not contains the id" do
      call_record_without_id = %{}
      call_record_with_empty_id = %{"id" => ""}
      call_record_with_nil_id = %{"id" => nil}

      assert CallRecordValidator.validate(call_record_without_id) == %{"errors" => ["call record don't have an id"]}
      assert CallRecordValidator.validate(call_record_with_empty_id) == %{"id" => "", "errors" => ["call record don't have an id"]}
      assert CallRecordValidator.validate(call_record_with_nil_id) == %{"id" => nil, "errors" => ["call record don't have an id"]}
    end
  end

end