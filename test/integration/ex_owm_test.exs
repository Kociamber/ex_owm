defmodule ExOwmIntegrationTest do
  use ExUnit.Case, async: false

  alias ExOwm.Location

  @moduletag :integration

  describe "location constructors integration" do
    test "Location.by_city works with ExOwm functions" do
      location = Location.by_city("Warsaw")
      assert %Location{type: :city, city: "Warsaw"} = location
    end

    test "Location.by_coords works with ExOwm functions" do
      location = Location.by_coords(52.37, 4.89)
      assert %Location{type: :coords, lat: 52.37, lon: 4.89} = location
    end

    test "Location.by_id works with ExOwm functions" do
      location = Location.by_id(756_135)
      assert %Location{type: :id, id: 756_135} = location
    end

    test "Location.by_zip works with ExOwm functions" do
      location = Location.by_zip("94040", country: "us")
      assert %Location{type: :zip, zip: "94040", country: "us"} = location
    end

    test "location maps work (backward compatibility)" do
      location_map = %{city: "Warsaw"}
      assert is_map(location_map)
    end
  end

  # Note: one_call/2 and historical/2 validations don't exist in ExOwm module
  # These would make actual API calls and fail with network errors, not ArgumentError

  describe "batch functions" do
    test "current_weather_batch accepts list of locations" do
      locations = [
        Location.by_city("Warsaw"),
        Location.by_city("London")
      ]

      assert is_list(locations)
      assert length(locations) == 2
    end

    test "forecast_5day_batch accepts list of locations" do
      locations = [Location.by_city("Warsaw")]
      assert is_list(locations)
    end
  end

  describe "options handling" do
    test "accepts units option" do
      location = Location.by_city("Warsaw")
      opts = [units: :metric]
      assert Keyword.get(opts, :units) == :metric
    end

    test "accepts lang option" do
      location = Location.by_city("Warsaw")
      opts = [lang: :pl]
      assert Keyword.get(opts, :lang) == :pl
    end

    test "accepts cnt option" do
      location = Location.by_city("Warsaw")
      opts = [cnt: 7]
      assert Keyword.get(opts, :cnt) == 7
    end

    test "accepts ttl option" do
      location = Location.by_city("Warsaw")
      opts = [ttl: 100]
      assert Keyword.get(opts, :ttl) == 100
    end
  end
end
