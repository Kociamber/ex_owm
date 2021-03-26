defmodule GetHistoricalWeatherTest do
  use ExUnit.Case

  test ": can get historical one call weather data by latitude and longitude" do
    # given
    yesterday =
      DateTime.utc_now() |> DateTime.add(24 * 60 * 60 * -1, :second) |> DateTime.to_unix()

    city = %{lat: 52.374031, lon: 4.88969, dt: yesterday}
    # when
    result = ExOwm.get_historical_weather([city])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    # kelvin, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") > 200
    # The first entry should be smaller than what we asked for because it's midnight.
    assert Map.get(map, "hourly") |> List.first() |> Map.get("dt") < yesterday
    assert Map.get(map, "hourly") |> Enum.count() == 24
  end

  test ": can get historical weather data with get_historical_weather/2 by latitude and longitude with options" do
    # given
    yesterday =
      DateTime.utc_now() |> DateTime.add(24 * 60 * 60 * -1, :second) |> DateTime.to_unix()

    city = %{lat: 46.514098, lon: 8.326755, dt: yesterday}
    options = [units: :metric, lang: :de]
    # when
    result = ExOwm.get_historical_weather([city], options)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # check whether map has specific keys to confirm that request was successful
    # Celsius, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") < 100
    # The first entry should be smaller than what we asked for because it's midnight.
    assert Map.get(map, "hourly") |> List.first() |> Map.get("dt") < yesterday
  end

  test ": Parses errors correctly" do
    # given
    city = %{lat: "15", lon: "-2", dt: -200}
    # when
    result = ExOwm.get_historical_weather(city)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []

    {:error, :not_found,
     %{"cod" => "400", "message" => "requested time is out of allowed range of 5 days back"}} =
      List.first(result)
  end
end
