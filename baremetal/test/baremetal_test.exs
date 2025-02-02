defmodule BaremetalTest do
  use ExUnit.Case
  doctest Baremetal

  test "greets the world" do
    assert Baremetal.hello() == :world
  end
end
