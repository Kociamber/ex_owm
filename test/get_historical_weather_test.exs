defmodule GetHistoricalWeatherTest do
  use ExUnit.Case

  setup do
    # Introduce a delay of 1 second between each test due to free API key restriction of 60 calls/minute
    :timer.sleep(1000)
    :ok
  end

  test "get_historical_weather/1 with a list of latitudes and longitudes" do
    yesterday =
      DateTime.utc_now() |> DateTime.add(24 * 60 * 60 * -1, :second) |> DateTime.to_unix()

    result = ExOwm.get_historical_weather([%{lat: 52.374031, lon: 4.88969, dt: yesterday}])

    assert is_list(result)
    assert result != []
    {:ok, map} = List.first(result)
    assert is_map(map)
    # kelvin, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") > 200
    # The first entry should be smaller than what we asked for because it's midnight.
    assert Map.get(map, "hourly") |> List.first() |> Map.get("dt") < yesterday
    assert Map.get(map, "hourly") |> Enum.count() == 24
  end

  test "get_historical_weather/2 with a list of latitudes and longitudes and options" do
    yesterday =
      DateTime.utc_now() |> DateTime.add(24 * 60 * 60 * -1, :second) |> DateTime.to_unix()

    result =
      ExOwm.get_historical_weather([%{lat: 46.514098, lon: 8.326755, dt: yesterday}],
        units: :metric,
        lang: :de
      )

    assert is_list(result)
    assert result != []

    {:ok, map} = List.first(result)

    assert is_map(map)
    # Celsius, we should be fine here
    assert Map.get(map, "current") |> Map.get("temp") < 100
    # The first entry should be smaller than what we asked for because it's midnight.
    assert Map.get(map, "hourly") |> List.first() |> Map.get("dt") < yesterday
  end

  test "get_historical_weather/2 with an incorrect coordinates" do
    city = %{lat: "15", lon: "-2", dt: -200}

    result = ExOwm.get_historical_weather(city)

    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []

    {:error, :not_found,
     %{"cod" => "400", "message" => "requested time is out of allowed range of 5 days back"}} =
      List.first(result)
  end
end
