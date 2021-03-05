defmodule GetFiveDayForecastTest do
  use ExUnit.Case

  test ": can get weather data with get_five_day_forecast/1 by single city name" do
    # given
    city = %{city: "Sochi"}
    # when
    result = ExOwm.get_five_day_forecast(city)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Sochi"
  end

  test ": can get weather data with get_five_day_forecast/1 by city name" do
    # given
    city = %{city: "Sochi"}
    # when
    result = ExOwm.get_five_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Sochi"
  end

  test ": can get weather data with get_five_day_forecast/1 by city name and country code" do
    # given
    city = %{city: "Warsaw", countr_code: "pl"}
    # when
    result = ExOwm.get_five_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  test ": can get weather data with get_five_day_forecast/1 by city id" do
    # given
    city = %{id: 2_759_794}
    # when
    result = ExOwm.get_five_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  test ": can get weather data with get_five_day_forecast/1 by latitude and longitude" do
    # given
    city = %{lat: 4.3942822222, lon: 18.558442503}
    # when
    result = ExOwm.get_five_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Kolongo"
  end

  test ": can get weather data with get_five_day_forecast/1 by zip and country code" do
    # given
    city = %{zip: "94040", country_code: "us"}
    # when
    result = ExOwm.get_five_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Mountain View"
  end

  test ": can get weather data with get_five_day_forecast/1 by city name with options" do
    # given
    city = %{city: "Moscow"}
    options = [units: :metric, lang: :ru]
    # when
    result = ExOwm.get_five_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Москва"
  end

  test ": can get weather data with get_five_day_forecast/1 by city name and country code with options" do
    # given
    city = %{city: "Freiburg", countr_code: "ch"}
    options = [units: :metric, lang: :fr]
    # when
    result = ExOwm.get_five_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    # Fribourg or Freiburg is a city which exists in multiple countries and in multiple languages
    assert city_name == "Fribourg"
    assert %{"city" => %{"country" => "CH"}} = map
  end

  test ": can get weather data with get_five_day_forecast/1 by city id with options" do
    # given
    city = %{id: 2_759_794}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_five_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  test ": can get weather data with get_five_day_forecast/1 by latitude and longitude with options" do
    # given
    city = %{lat: 52.374031, lon: 4.88969}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_five_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  test ": can get weather data with get_five_day_forecast/1 by zip and country code with options" do
    # given
    city = %{zip: "94040", country_code: "us"}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_five_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Mountain View"
  end
end
