defmodule GetSixteenDayForecastTest do
  use ExUnit.Case

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by single city name" do
    # given
    city = %{city: "Warsaw"}
    # when
    result = ExOwm.get_sixteen_day_forecast(city)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by city name" do
    # given
    city = %{city: "Warsaw"}
    # when
    result = ExOwm.get_sixteen_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by city name and country code" do
    # given
    city = %{city: "Warsaw", countr_code: "pl"}
    # when
    result = ExOwm.get_sixteen_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by city id" do
    # given
    city = %{id: 2_759_794}
    # when
    result = ExOwm.get_sixteen_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by latitude and longitude" do
    # given
    city = %{lat: 52.374031, lon: 4.88969}
    # when
    result = ExOwm.get_sixteen_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by zip and country code" do
    # given
    city = %{zip: "94040", country_code: "us"}
    # when
    result = ExOwm.get_sixteen_day_forecast([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Mountain View"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by city name with options" do
    # given
    city = %{city: "Warsaw"}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_sixteen_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by city name and country code with options" do
    # given
    city = %{city: "Warsaw", countr_code: "pl"}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_sixteen_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Warsaw"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by city id with options" do
    # given
    city = %{id: 2_759_794}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_sixteen_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by latitude and longitude with options" do
    # given
    city = %{lat: 52.374031, lon: 4.88969}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_sixteen_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Amsterdam"
  end

  @tag :skip
  test ": can get weather data with get_sixteen_day_forecast/1 by zip and country code with options" do
    # given
    city = %{zip: "94040", country_code: "us"}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_sixteen_day_forecast([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check whether map has specific value to confirm that request was successful
    city_name =
      map
      |> Map.get("city")
      |> Map.get("name")

    assert city_name == "Mountain View"
  end
end
