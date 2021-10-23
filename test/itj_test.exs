defmodule ItjTest do
  use ExUnit.Case
  doctest Itj

  test "greets the world" do
    assert Itj.hello() == :world
  end
end
