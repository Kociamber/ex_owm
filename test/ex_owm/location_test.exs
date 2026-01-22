defmodule ExOwm.LocationTest do
  use ExUnit.Case, async: true

  alias ExOwm.Location

  describe "by_city/2" do
    test "creates location with city only" do
      assert %Location{type: :city, city: "Warsaw", country: nil} =
               Location.by_city("Warsaw")
    end

    test "creates location with city and country" do
      assert %Location{type: :city, city: "Warsaw", country: "pl"} =
               Location.by_city("Warsaw", country: "pl")
    end

    test "raises on non-string city name" do
      assert_raise FunctionClauseError, fn ->
        Location.by_city(123)
      end
    end

    test "accepts any string as country code" do
      assert %Location{country: "p"} = Location.by_city("Warsaw", country: "p")
      assert %Location{country: "pol"} = Location.by_city("Warsaw", country: "pol")
    end

    test "accepts uppercase country codes" do
      assert %Location{country: "PL"} = Location.by_city("Warsaw", country: "PL")
    end
  end

  describe "by_coords/3" do
    test "creates location with valid coordinates" do
      assert %Location{type: :coords, lat: 52.2297, lon: 21.0122, dt: nil} =
               Location.by_coords(52.2297, 21.0122)
    end

    test "accepts coordinates at edges" do
      assert %Location{lat: 90.0, lon: 180.0} = Location.by_coords(90.0, 180.0)
      assert %Location{lat: -90.0, lon: -180.0} = Location.by_coords(-90.0, -180.0)
    end

    test "raises on latitude too high" do
      assert_raise ArgumentError, "latitude must be between -90 and 90, got: 91.0", fn ->
        Location.by_coords(91.0, 0.0)
      end
    end

    test "raises on latitude too low" do
      assert_raise ArgumentError, "latitude must be between -90 and 90, got: -91.0", fn ->
        Location.by_coords(-91.0, 0.0)
      end
    end

    test "raises on longitude too high" do
      assert_raise ArgumentError, "longitude must be between -180 and 180, got: 181.0", fn ->
        Location.by_coords(0.0, 181.0)
      end
    end

    test "raises on longitude too low" do
      assert_raise ArgumentError, "longitude must be between -180 and 180, got: -181.0", fn ->
        Location.by_coords(0.0, -181.0)
      end
    end

    test "accepts integer coordinates" do
      assert %Location{lat: 52.0, lon: 21.0} = Location.by_coords(52, 21)
    end
  end

  describe "by_id/1" do
    test "creates location with positive ID" do
      assert %Location{type: :id, id: 756_135} = Location.by_id(756_135)
    end

    test "raises on zero ID" do
      assert_raise FunctionClauseError, fn ->
        Location.by_id(0)
      end
    end

    test "raises on negative ID" do
      assert_raise FunctionClauseError, fn ->
        Location.by_id(-1)
      end
    end

    test "raises on non-integer ID" do
      assert_raise FunctionClauseError, fn ->
        Location.by_id("123")
      end
    end
  end

  describe "by_zip/2" do
    test "creates location with zip and country" do
      assert %Location{type: :zip, zip: "94040", country: "us"} =
               Location.by_zip("94040", country: "us")
    end

    test "raises on missing country" do
      assert_raise KeyError, fn ->
        Location.by_zip("94040", [])
      end
    end

    test "accepts various zip formats" do
      assert %Location{zip: "12345"} = Location.by_zip("12345", country: "us")
      assert %Location{zip: "SW1A 1AA"} = Location.by_zip("SW1A 1AA", country: "uk")
      assert %Location{zip: "00-950"} = Location.by_zip("00-950", country: "pl")
    end
  end

  describe "with_timestamp/2" do
    test "adds timestamp to coords location" do
      location = Location.by_coords(52.37, 4.89)
      timestamp = 1_643_723_400

      assert %Location{dt: ^timestamp} = Location.with_timestamp(location, timestamp)
    end

    test "raises on negative timestamp" do
      location = Location.by_coords(52.37, 4.89)

      assert_raise FunctionClauseError, fn ->
        Location.with_timestamp(location, -1)
      end
    end

    test "raises on zero timestamp" do
      location = Location.by_coords(52.37, 4.89)

      assert_raise FunctionClauseError, fn ->
        Location.with_timestamp(location, 0)
      end
    end
  end

  describe "from_map/1" do
    test "converts city map to location" do
      assert %Location{type: :city, city: "Warsaw"} =
               Location.from_map(%{city: "Warsaw"})
    end

    test "converts city with country map to location" do
      assert %Location{type: :city, city: "Warsaw", country: "pl"} =
               Location.from_map(%{city: "Warsaw", country_code: "pl"})
    end

    test "converts id map to location" do
      assert %Location{type: :id, id: 756_135} =
               Location.from_map(%{id: 756_135})
    end

    test "converts coords map to location" do
      assert %Location{type: :coords, lat: 52.37, lon: 4.89} =
               Location.from_map(%{lat: 52.37, lon: 4.89})
    end

    test "converts coords with timestamp map to location" do
      assert %Location{type: :coords, lat: 52.37, lon: 4.89, dt: 1_643_723_400} =
               Location.from_map(%{lat: 52.37, lon: 4.89, dt: 1_643_723_400})
    end

    test "converts zip map to location" do
      assert %Location{type: :zip, zip: "94040", country: "us"} =
               Location.from_map(%{zip: "94040", country_code: "us"})
    end

    test "raises for invalid map" do
      assert_raise ArgumentError, ~r/Invalid location map/, fn ->
        Location.from_map(%{})
      end
    end

    test "raises when validation fails" do
      assert_raise ArgumentError, "latitude must be between -90 and 90, got: 91.0", fn ->
        Location.from_map(%{lat: 91.0, lon: 0.0})
      end
    end
  end
end
