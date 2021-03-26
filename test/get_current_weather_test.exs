defmodule GetCurrentWeatherTest do
  use ExUnit.Case

  test ": can get weather data with get_current_weather/1 by city name" do
    # given
    city = %{city: "Bengaluru"}
    # when
    result = ExOwm.get_current_weather(city)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Bengaluru"
  end

  test ": can get weather data with get_current_weather/1 by city name list" do
    # given
    city = %{city: "Lucerne"}
    # when
    result = ExOwm.get_current_weather([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Lucerne"
  end

  test ": can get weather data with get_current_weather/1 by city name and country code" do
    # given
    city = %{city: "Munich", countr_code: "de"}
    # when
    result = ExOwm.get_current_weather([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Munich"
  end

  test ": can get weather data with get_current_weather/1 by city id" do
    # given
    city = %{id: 2_759_794}
    # when
    result = ExOwm.get_current_weather([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test ": can get weather data with get_current_weather/1 by latitude and longitude" do
    # given
    city = %{lat: 52.374031, lon: 4.88969}
    # when
    result = ExOwm.get_current_weather([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test ": can get weather data with get_current_weather/1 by zip and country code" do
    # given
    city = %{zip: "94040", country_code: "us"}
    # when
    result = ExOwm.get_current_weather([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Mountain View"
  end

  test ": can get weather data with get_current_weather/1 by city name with options" do
    # given
    city = %{city: "Warsaw"}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_current_weather([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Warszawa"
  end

  test ": can get weather data with get_current_weather/1 by city name and country code with options" do
    # given
    city = %{city: "Warsaw", countr_code: "pl"}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_current_weather([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Warszawa"
  end

  test ": can get weather data with get_current_weather/1 by city id with options" do
    # given
    city = %{id: 2_759_794}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_current_weather([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test ": can get weather data with get_current_weather/1 by latitude and longitude with options" do
    # given
    city = %{lat: 52.374031, lon: 4.88969}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_current_weather([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Amsterdam" or "Gemeente Amsterdam"
  end

  test ": can get weather data with get_current_weather/1 by zip and country code with options" do
    # given
    city = %{zip: "94040", country_code: "us"}
    options = [units: :metric, lang: :pl]
    # when
    result = ExOwm.get_current_weather([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "name") == "Mountain View"
  end

  test ": Parses errors correctly" do
    # given
    city = %{city: "unknown city, yes, really unknown"}
    # when
    result = ExOwm.get_current_weather(city)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:error, :not_found, %{"cod" => "404", "message" => "city not found"}} = List.first(result)
  end
end
