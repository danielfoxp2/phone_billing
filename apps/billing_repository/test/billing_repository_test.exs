defmodule BillingRepositoryTest do
  use ExUnit.Case
  doctest BillingRepository

  test "greets the world" do
    assert BillingRepository.hello() == :world
  end
end
