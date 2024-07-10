defmodule GetHourlyForecastTest do
  use ExUnit.Case

  setup do
    # Introduce a delay of 1 second between each test due to free API key restriction of 60 calls/minute
    :timer.sleep(1000)
    :ok
  end

  @tag :api_based_test
  test "get_hourly_forecast/1 with a city name" do
    result = ExOwm.get_hourly_forecast(%{city: "Sochi"})

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Sochi"
  end

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of cities" do
    result = ExOwm.get_hourly_forecast([%{city: "Sochi"}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Sochi"
  end

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of cities and country codes" do
    city = %{city: "Warsaw", countr_code: "pl"}

    result = ExOwm.get_hourly_forecast([city])

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

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of city ids" do
    result = ExOwm.get_hourly_forecast([%{id: 2_759_794}])

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

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of coordinates" do
    result = ExOwm.get_hourly_forecast([%{lat: 4.3942822222, lon: 18.558442503}])

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Kolongo"
    assert map |> Map.get("list") |> Enum.count() == 96
  end

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of zip codes and country codes" do
    result = ExOwm.get_hourly_forecast([%{zip: "94040", country_code: "us"}])

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

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of cities and options" do
    result = ExOwm.get_hourly_forecast([%{city: "Zurich"}], units: :metric, lang: :ch)

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Zurich"
  end

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of cities, country codes and options" do
    result =
      ExOwm.get_hourly_forecast([%{city: "Freiburg", countr_code: "ch"}],
        units: :metric,
        lang: :fr
      )

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)

    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    # Fribourg or Freiburg is a city which exists in multiple countries and in multiple languages
    assert city_name == "Fribourg"
    assert %{"city" => %{"country" => "CH"}} = map
  end

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of city ids and options" do
    result = ExOwm.get_hourly_forecast([%{id: 2_759_794}], units: :metric, lang: :pl)

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

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of coordinates and options" do
    result =
      ExOwm.get_hourly_forecast([%{lat: 52.374031, lon: 4.88969}], units: :metric, lang: :pl)

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

  @tag :api_based_test
  test "get_hourly_forecast/1 with a list of zip codes, country codes and options" do
    result =
      ExOwm.get_hourly_forecast([%{zip: "94040", country_code: "us"}], units: :metric, lang: :pl)

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
