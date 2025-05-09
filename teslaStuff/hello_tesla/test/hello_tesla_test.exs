defmodule HelloTeslaTest do
  use ExUnit.Case
  doctest HelloTesla

  test "greets the world" do
    assert HelloTesla.hello() == :world
  end
end
