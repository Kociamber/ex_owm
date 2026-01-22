defmodule ExOwm.RequestURLTest do
  use ExUnit.Case, async: false

  alias ExOwm.{Location, RequestURL}

  setup do
    # Set API key for tests
    Application.put_env(:ex_owm, :api_key, "test_api_key_123")

    on_exit(fn ->
      Application.delete_env(:ex_owm, :api_key)
    end)

    :ok
  end

  describe "build_url/3 for current weather" do
    test "builds URL for city" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "https://api.openweathermap.org/data/2.5/weather?"
      assert url =~ "q=Warsaw"
      assert url =~ "APPID=test_api_key_123"
    end

    test "builds URL for city with country" do
      location = Location.by_city("Warsaw", country: "pl")
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "q=Warsaw%2Cpl"
    end

    test "builds URL for coordinates" do
      location = Location.by_coords(52.37, 4.89)
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "lat=52.37"
      assert url =~ "lon=4.89"
    end

    test "builds URL for city ID" do
      location = Location.by_id(756_135)
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "id=756135"
    end

    test "builds URL for zip code" do
      location = Location.by_zip("94040", country: "us")
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "zip=94040%2Cus"
    end

    test "includes units parameter" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_current_weather, location, units: :metric)

      assert url =~ "units=metric"
    end

    test "includes lang parameter" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_current_weather, location, lang: :pl)

      assert url =~ "lang=pl"
    end

    test "includes mode parameter" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_current_weather, location, mode: :xml)

      assert url =~ "mode=xml"
    end
  end

  describe "build_url/3 for one call" do
    test "builds URL for one call API" do
      location = Location.by_coords(52.37, 4.89)
      url = RequestURL.build_url(:get_weather, location, [])

      assert url =~ "https://api.openweathermap.org/data/2.5/onecall?"
      assert url =~ "lat=52.37"
      assert url =~ "lon=4.89"
      assert url =~ "APPID=test_api_key_123"
    end
  end

  describe "build_url/3 for historical weather" do
    test "builds URL for historical weather" do
      location = Location.by_coords(52.37, 4.89) |> Location.with_timestamp(1_643_723_400)
      url = RequestURL.build_url(:get_historical_weather, location, [])

      assert url =~ "https://api.openweathermap.org/data/2.5/onecall/timemachine?"
      assert url =~ "lat=52.37"
      assert url =~ "lon=4.89"
      assert url =~ "dt=1643723400"
      assert url =~ "APPID=test_api_key_123"
    end
  end

  describe "build_url/3 for forecasts" do
    test "builds URL for 5-day forecast" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_five_day_forecast, location, [])

      assert url =~ "https://api.openweathermap.org/data/2.5/forecast?"
      assert url =~ "q=Warsaw"
      assert url =~ "APPID=test_api_key_123"
    end

    test "builds URL for hourly forecast" do
      location = Location.by_coords(52.37, 4.89)
      url = RequestURL.build_url(:get_hourly_forecast, location, [])

      assert url =~ "https://pro.openweathermap.org/data/2.5/forecast/hourly?"
      assert url =~ "lat=52.37"
      assert url =~ "lon=4.89"
    end

    test "builds URL for 16-day forecast" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_sixteen_day_forecast, location, cnt: 7)

      assert url =~ "https://api.openweathermap.org/data/2.5/forecast/daily?"
      assert url =~ "q=Warsaw"
      assert url =~ "cnt=7"
    end
  end

  describe "build_url/3 with special characters" do
    test "encodes spaces in city names" do
      location = Location.by_city("New York")
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "q=New+York"
    end

    test "encodes special characters in zip codes" do
      location = Location.by_zip("SW1A 1AA", country: "uk")
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "zip=SW1A+1AA%2Cuk"
    end
  end

  describe "build_url/3 parameter handling" do
    test "includes APPID parameter" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_current_weather, location, [])

      assert url =~ "APPID=test_api_key_123"
    end

    test "includes type parameter when provided" do
      location = Location.by_city("Warsaw")
      url = RequestURL.build_url(:get_current_weather, location, type: :accurate)

      assert url =~ "type=accurate"
    end
  end
end
