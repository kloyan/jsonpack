defmodule JsonpackTest do
  use ExUnit.Case
  doctest Jsonpack

  test "greets the world" do
    assert Jsonpack.hello() == :world
  end
end
