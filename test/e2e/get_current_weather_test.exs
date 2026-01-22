defmodule GetCurrentWeatherTest do
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
  test "current_weather/2 with Location.by_city" do
    location = Location.by_city("Bengaluru")
    assert {:ok, map} = ExOwm.current_weather(location)
    assert is_map(map)
    assert Map.get(map, "name") == "Bengaluru"
  end

  @tag :api_based_test
  test "current_weather_batch/2 with multiple locations" do
    locations = [
      Location.by_city("Lucerne"),
      Location.by_city("Warsaw")
    ]

    results = ExOwm.current_weather_batch(locations)
    assert is_list(results)
    assert length(results) == 2

    assert Enum.all?(results, fn
             {:ok, map} -> is_map(map)
             _ -> false
           end)
  end

  @tag :api_based_test
  test "current_weather/2 with Location.by_city and country" do
    location = Location.by_city("Munich", country: "de")
    assert {:ok, map} = ExOwm.current_weather(location)
    assert is_map(map)
    assert Map.get(map, "name") == "Munich"
  end

  @tag :api_based_test
  test "current_weather/2 with Location.by_id" do
    location = Location.by_id(2_759_794)
    assert {:ok, map} = ExOwm.current_weather(location)
    assert is_map(map)
    name = Map.get(map, "name")
    assert name in ["Amsterdam", "Gemeente Amsterdam"]
  end

  @tag :api_based_test
  test "current_weather/2 with Location.by_coords" do
    location = Location.by_coords(52.374031, 4.88969)
    assert {:ok, map} = ExOwm.current_weather(location)
    assert is_map(map)
    name = Map.get(map, "name")
    assert name in ["Amsterdam", "Gemeente Amsterdam"]
  end

  @tag :api_based_test
  test "current_weather/2 with Location.by_zip" do
    location = Location.by_zip("94040", country: "us")
    assert {:ok, map} = ExOwm.current_weather(location)
    assert is_map(map)
    assert Map.get(map, "name") == "Mountain View"
  end

  @tag :api_based_test
  test "current_weather/2 with options" do
    location = Location.by_city("Warsaw")
    options = [units: :metric, lang: :pl]

    assert {:ok, map} = ExOwm.current_weather(location, options)
    assert is_map(map)
    assert Map.get(map, "name") == "Warszawa"
  end

  @tag :api_based_test
  test "current_weather/2 with non-existing city" do
    location = Location.by_city("Bonkersville")

    assert {:error, :not_found, %{"cod" => "404", "message" => "city not found"}} =
             ExOwm.current_weather(location)
  end

  # ============================================================================
  # Deprecated API tests (v1.x backward compatibility)
  # ============================================================================

  @tag :api_based_test
  test "get_current_weather/1 with a city name (deprecated)" do
    result = ExOwm.get_current_weather(%{city: "Bengaluru"})
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Bengaluru"
  end

  @tag :api_based_test
  test "get_current_weather/1 with a list of cities (deprecated)" do
    result = ExOwm.get_current_weather([%{city: "Lucerne"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Lucerne"
  end

  @tag :api_based_test
  test "get_current_weather/1 with a city name and a country code (deprecated)" do
    result = ExOwm.get_current_weather([%{city: "Munich", country_code: "de"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Munich"
  end

  @tag :api_based_test
  test "get_current_weather/1 with a city id (deprecated)" do
    result = ExOwm.get_current_weather([%{id: 2_759_794}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)
    assert is_map(map)
    name = Map.get(map, "name")
    assert name in ["Amsterdam", "Gemeente Amsterdam"]
  end

  @tag :api_based_test
  test "get_current_weather/1 with a latitude and a longitude (deprecated)" do
    result = ExOwm.get_current_weather([%{lat: 52.374031, lon: 4.88969}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    name = Map.get(map, "name")
    assert name in ["Amsterdam", "Gemeente Amsterdam"]
  end

  @tag :api_based_test
  test "get_current_weather/1 with a zip and a country code (deprecated)" do
    result = ExOwm.get_current_weather([%{zip: "94040", country_code: "us"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Mountain View"
  end

  @tag :api_based_test
  test "get_current_weather/1 with a city name and options (deprecated)" do
    city = %{city: "Warsaw"}
    options = [units: :metric, lang: :pl]

    result = ExOwm.get_current_weather([city], options)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Warszawa"
  end
end
