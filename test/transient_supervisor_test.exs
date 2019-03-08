defmodule TransientSupervisorTest do
  use ExUnit.Case
  doctest TransientSupervisor

  test "greets the world" do
    assert TransientSupervisor.hello() == :world
  end
end
