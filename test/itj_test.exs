defmodule ITJTest do
  use ExUnit.Case
  doctest ITJ

  test "greets the world" do
    assert ITJ.hello() == :world
  end
end
