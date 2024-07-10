defmodule GetSixteenDayForecastTest do
  use ExUnit.Case

  setup do
    # Introduce a delay of 1 second between each test due to free API key restriction of 60 calls/minute
    :timer.sleep(1000)
    :ok
  end

  test "get_sixteen_day_forecast/1 with a city name" do
    result = ExOwm.get_sixteen_day_forecast(%{city: "Warsaw"})

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  test "get_sixteen_day_forecast/1 with a list of cities" do
    result = ExOwm.get_sixteen_day_forecast([%{city: "Warsaw"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  test "get_sixteen_day_forecast/1 with a list of city names and country codes" do
    result = ExOwm.get_sixteen_day_forecast([%{city: "Warsaw", countr_code: "pl"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  test "get_sixteen_day_forecast/1 with a list of city ids" do
    result = ExOwm.get_sixteen_day_forecast([%{id: 2_759_794}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  test "get_sixteen_day_forecast/1 with a list of coordinates" do
    result = ExOwm.get_sixteen_day_forecast([%{lat: 52.374031, lon: 4.88969}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  test "get_sixteen_day_forecast/1 with a list of zip does and country codes" do
    result = ExOwm.get_sixteen_day_forecast([%{zip: "94040", country_code: "us"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Mountain View"
  end

  test "get_sixteen_day_forecast/1 with a list of city names and options" do
    result = ExOwm.get_sixteen_day_forecast([%{city: "Warsaw"}], units: :metric, lang: :pl)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  test "get_sixteen_day_forecast/1 with a list of city names, country codes and options" do
    result =
      ExOwm.get_sixteen_day_forecast([%{city: "Warsaw", countr_code: "pl"}],
        units: :metric,
        lang: :pl
      )

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  test "get_sixteen_day_forecast/1 with a list of city ids and options" do
    result = ExOwm.get_sixteen_day_forecast([%{id: 2_759_794}], units: :metric, lang: :pl)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  test "get_sixteen_day_forecast/1 with a list of coordinates and options" do
    result =
      ExOwm.get_sixteen_day_forecast([%{lat: 52.374031, lon: 4.88969}], units: :metric, lang: :pl)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  test "get_sixteen_day_forecast/1 with a list of zip codes, country codes and options" do
    result =
      ExOwm.get_sixteen_day_forecast([%{zip: "94040", country_code: "us"}],
        units: :metric,
        lang: :pl
      )

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Mountain View"
  end
end
