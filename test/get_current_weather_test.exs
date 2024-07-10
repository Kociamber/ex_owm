defmodule GetCurrentWeatherTest do
  use ExUnit.Case

  setup do
    # Introduce a delay of 1 second between each test due to free API key restriction of 60 calls/minute
    :timer.sleep(1000)
    :ok
  end

  test ":get_current_weather/1 with a city name" do
    result = ExOwm.get_current_weather(%{city: "Bengaluru"})
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Bengaluru"
  end

  test ":get_current_weather/1 with a list of cities" do
    result = ExOwm.get_current_weather([%{city: "Lucerne"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Lucerne"
  end

  test "get_current_weather/1 with a city name and a country code" do
    result = ExOwm.get_current_weather([%{city: "Munich", countr_code: "de"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Munich"
  end

  test ":get_current_weather/1 with a city id" do
    result = ExOwm.get_current_weather([%{id: 2_759_794}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)
    assert is_map(map)
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test "get_current_weather/1 with a latitude and a longitude" do
    result = ExOwm.get_current_weather([%{lat: 52.374031, lon: 4.88969}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test "get_current_weather/1 with a zip and a country code" do
    result = ExOwm.get_current_weather([%{zip: "94040", country_code: "us"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Mountain View"
  end

  test "get_current_weather/1 with a city name and options" do
    city = %{city: "Warsaw"}
    options = [units: :metric, lang: :pl]

    result = ExOwm.get_current_weather([city], options)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Warszawa"
  end

  test "get_current_weather/1 with a city name and a country code and options" do
    city = %{city: "Warsaw", countr_code: "pl"}
    options = [units: :metric, lang: :pl]

    result = ExOwm.get_current_weather([city], options)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Warszawa"
  end

  test "get_current_weather/1 with a city id and options" do
    city = %{id: 2_759_794}
    options = [units: :metric, lang: :pl]

    result = ExOwm.get_current_weather([city], options)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test "get_current_weather/1 with a latitude and a longitude and options" do
    city = %{lat: 52.374031, lon: 4.88969}
    options = [units: :metric, lang: :pl]

    result = ExOwm.get_current_weather([city], options)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test "get_current_weather/1 with a zip code, a country code and options" do
    city = %{zip: "94040", country_code: "us"}
    options = [units: :metric, lang: :pl]

    result = ExOwm.get_current_weather([city], options)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    assert Map.get(map, "name") == "Mountain View"
  end

  test "get_current_weather/1 with non-existing city" do
    result = ExOwm.get_current_weather(%{city: "Bonkersville"})

    assert result == [
             {:error, :not_found, {:ok, %{"cod" => "404", "message" => "city not found"}}}
           ]
  end
end
