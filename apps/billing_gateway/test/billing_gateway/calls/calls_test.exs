defmodule BillingGateway.CallsTest do
  use BillingGateway.DataCase

  alias BillingGateway.Calls

  describe "call_records" do
    alias BillingGateway.Calls.CallRecord

    @valid_attrs %{call_id: 42, destination: "some destination", id: 42, source: "some source", timestamp: "some timestamp", type: "some type"}
    @update_attrs %{call_id: 43, destination: "some updated destination", id: 43, source: "some updated source", timestamp: "some updated timestamp", type: "some updated type"}
    @invalid_attrs %{call_id: nil, destination: nil, id: nil, source: nil, timestamp: nil, type: nil}

    def call_record_fixture(attrs \\ %{}) do
      {:ok, call_record} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Calls.create_call_record()

      call_record
    end

    test "list_call_records/0 returns all call_records" do
      call_record = call_record_fixture()
      assert Calls.list_call_records() == [call_record]
    end

    test "get_call_record!/1 returns the call_record with given id" do
      call_record = call_record_fixture()
      assert Calls.get_call_record!(call_record.id) == call_record
    end

    test "create_call_record/1 with valid data creates a call_record" do
      assert {:ok, %CallRecord{} = call_record} = Calls.create_call_record(@valid_attrs)
      assert call_record.call_id == 42
      assert call_record.destination == "some destination"
      assert call_record.id == 42
      assert call_record.source == "some source"
      assert call_record.timestamp == "some timestamp"
      assert call_record.type == "some type"
    end

    test "create_call_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calls.create_call_record(@invalid_attrs)
    end

    test "update_call_record/2 with valid data updates the call_record" do
      call_record = call_record_fixture()
      assert {:ok, call_record} = Calls.update_call_record(call_record, @update_attrs)
      assert %CallRecord{} = call_record
      assert call_record.call_id == 43
      assert call_record.destination == "some updated destination"
      assert call_record.id == 43
      assert call_record.source == "some updated source"
      assert call_record.timestamp == "some updated timestamp"
      assert call_record.type == "some updated type"
    end

    test "update_call_record/2 with invalid data returns error changeset" do
      call_record = call_record_fixture()
      assert {:error, %Ecto.Changeset{}} = Calls.update_call_record(call_record, @invalid_attrs)
      assert call_record == Calls.get_call_record!(call_record.id)
    end

    test "delete_call_record/1 deletes the call_record" do
      call_record = call_record_fixture()
      assert {:ok, %CallRecord{}} = Calls.delete_call_record(call_record)
      assert_raise Ecto.NoResultsError, fn -> Calls.get_call_record!(call_record.id) end
    end

    test "change_call_record/1 returns a call_record changeset" do
      call_record = call_record_fixture()
      assert %Ecto.Changeset{} = Calls.change_call_record(call_record)
    end
  end
end
