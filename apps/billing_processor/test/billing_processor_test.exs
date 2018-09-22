defmodule BillingProcessorTest do
  use ExUnit.Case
  doctest BillingProcessor

  test "greets the world" do
    assert BillingProcessor.hello() == :world
  end
end
