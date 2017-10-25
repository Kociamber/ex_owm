defmodule ExOwmTest do
  use ExUnit.Case
  doctest ExOwm

  test ": can get temperature for a given location" do
    # given
    location = "Warsaw"
    # when
    result = ExOwm.get_weather(location)
    # then
    assert is_map(result)
  end
end
