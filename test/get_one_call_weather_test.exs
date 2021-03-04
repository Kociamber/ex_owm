defmodule GetOneCallWeatherTest do
  use ExUnit.Case

  test ": can get one call weather data by latitude and longitude" do
    # given
    city = %{lat: 52.374031, lon: 4.88969}
    # when
    result = ExOwm.get_weather([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "current") |> Map.get("temp") > 200 # kelvin, we should be fine here
  end

  test ": can get weather data with get_current_weather/1 by latitude and longitude with options" do
    # given
    city = %{lat: 46.514098, lon: 8.326755}
    options = [units: :metric, lang: :ru]
    # when
    result = ExOwm.get_weather([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    assert Map.get(map, "current") |> Map.get("temp") < 100 # Celsius, we should be fine here
  end

  test ": Parses errors correctly" do
    # given
    city = %{lat: "800", lon: "-2"}
    # when
    result = ExOwm.get_weather(city)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:error, :not_found, %{"cod" => "400", "message" => "wrong latitude"}} = List.first(result)
  end

end
