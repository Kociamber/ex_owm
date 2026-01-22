defmodule GetOneCallWeatherTest do
  use ExUnit.Case

  alias ExOwm.Location

  setup do
    # Introduce a delay of 1 second between each test due to free API key restriction of 60 calls/minute
    :timer.sleep(1000)
    :ok
  end

  # ============================================================================
  # New API tests (v2.0)
  # ============================================================================

  @tag :api_based_test
  test "one_call/2 with Location.by_coords" do
    location = Location.by_coords(52.374031, 4.88969)
    assert {:ok, map} = ExOwm.one_call(location)

    assert is_map(map)
    # kelvin, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") > 200
  end

  @tag :api_based_test
  test "one_call/2 with coordinates and options" do
    location = Location.by_coords(46.514098, 8.326755)
    options = [units: :metric, lang: :ru]

    assert {:ok, map} = ExOwm.one_call(location, options)

    assert is_map(map)
    # Celsius, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") < 100
  end

  @tag :api_based_test
  test "one_call/2 with incorrect coordinates" do
    location = Location.by_city("NonExistentCity")

    assert {:error, :not_found, _} = ExOwm.one_call(location)
  end

  # ============================================================================
  # Deprecated API tests (v1.x backward compatibility)
  # ============================================================================

  @tag :api_based_test
  test "get_weather/1 with a list of coordinates (deprecated)" do
    result = ExOwm.get_weather([%{lat: 52.374031, lon: 4.88969}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    # kelvin, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") > 200
  end

  @tag :api_based_test
  test "get_weather/1 with a list of coordinates and options (deprecated)" do
    city = %{lat: 46.514098, lon: 8.326755}
    options = [units: :metric, lang: :ru]

    result = ExOwm.get_weather([city], options)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    # Celsius, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") < 100
  end

  @tag :api_based_test
  test "get_weather/1 with an incorrect coordinates (deprecated)" do
    city = %{lat: "800", lon: "-2"}

    result = ExOwm.get_weather(city)

    assert is_list(result)
    assert result != []
    {:error, :not_found, %{"cod" => "400", "message" => "wrong latitude"}} = List.first(result)
  end
end
