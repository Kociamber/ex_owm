defmodule ExOwm do
  @moduledoc """
  ExOwm, OpenWeatherMap API Elixir client.

  This module provides the main public interface for fetching weather data
  from OpenWeatherMap APIs.

  ## Quick Start

      # Using location constructors (recommended)
      location = ExOwm.Location.by_city("Warsaw", country: "pl")
      {:ok, weather} = ExOwm.current_weather(location, units: :metric)

      # Using location maps (backward compatibility)
      {:ok, weather} = ExOwm.current_weather(%{city: "Warsaw"}, units: :metric)

  ## Batch Requests

      locations = [
        ExOwm.Location.by_city("Warsaw"),
        ExOwm.Location.by_city("London", country: "uk"),
        ExOwm.Location.by_coords(52.374031, 4.88969)
      ]

      results = ExOwm.current_weather_batch(locations, units: :metric, lang: :pl)
      # Returns: [ok: data1, ok: data2, ok: data3]

  ## Available Endpoints

  ### Weather Data
    * `current_weather/2` - Current weather data
    * `one_call/2` - One Call API (current + forecast + historical in one call)
    * `forecast_5day/2` - 5 day / 3 hour forecast
    * `forecast_hourly/2` - 4 day hourly forecast (requires paid plan)
    * `forecast_16day/2` - 1-16 day daily forecast
    * `historical/2` - Historical weather data (last 5 days)

  ### Air Quality
    * `air_pollution/2` - Current air pollution data (AQI, CO, NO, NO2, O3, SO2, NH3, PM2.5, PM10)
    * `air_pollution_forecast/2` - 4-day hourly air pollution forecast
    * `air_pollution_history/2` - Historical air pollution data (requires `start` and `end` timestamps)

  ### Geocoding
    * `geocode/2` - Convert location name to coordinates
    * `reverse_geocode/3` - Convert coordinates to location name

  Each weather endpoint has a corresponding `*_batch/2` variant for multiple locations.

  ## Options

    * `:units` - `:metric`, `:imperial`, or `:standard` (default: Kelvin)
    * `:lang` - Language code as atom (e.g., `:pl`, `:en`, `:ru`)
    * `:cnt` - Number of forecast days (for 16-day forecast, 1-16)
    * `:ttl` - Cache TTL in milliseconds (overrides default)

  ## Telemetry

  ExOwm emits the following telemetry events:

    * `[:ex_owm, :request, :start]` - When a request starts
    * `[:ex_owm, :request, :stop]` - When a request completes

  Metadata includes: endpoint, location, cache hit/miss, duration, result.

  """

  alias ExOwm.{Client, Location}

  @typedoc "Location specification - either a Location struct or a location map"
  @type location :: Location.t() | map()

  @typedoc "Request options"
  @type options :: keyword()

  @typedoc "Single request result"
  @type result :: {:ok, map()} | {:error, term()} | {:error, term(), term()}

  @typedoc "Batch request results"
  @type batch_results :: [result()]

  # ============================================================================
  # API (v2.0)
  # ============================================================================

  @doc """
  Fetches current weather data for a location.

  ## Parameters

    * `location` - A `%ExOwm.Location{}` struct or location map
    * `opts` - Request options (units, lang, etc.)

  ## Examples

      iex> location = ExOwm.Location.by_city("Warsaw")
      iex> ExOwm.current_weather(location, units: :metric, lang: :pl)
      {:ok, %{"name" => "Warszawa", ...}}

      iex> ExOwm.current_weather(%{city: "London", country_code: "uk"})
      {:ok, %{"name" => "London", ...}}

  """
  @spec current_weather(location(), options()) :: result()
  def current_weather(location, opts \\ []) do
    Client.fetch(:current_weather, location, opts)
  end

  @doc """
  Fetches current weather data for multiple locations concurrently.

  ## Examples

      iex> locations = [
      ...>   ExOwm.Location.by_city("Warsaw"),
      ...>   ExOwm.Location.by_city("London", country: "uk")
      ...> ]
      iex> ExOwm.current_weather_batch(locations, units: :metric)
      [{:ok, %{"name" => "Warszawa"}}, {:ok, %{"name" => "London"}}]

  """
  @spec current_weather_batch([location()], options()) :: batch_results()
  def current_weather_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:current_weather, locations, opts)
  end

  @doc """
  Fetches weather data using the One Call API.

  The One Call API provides current weather, minute forecast for 1 hour,
  hourly forecast for 48 hours, daily forecast for 7 days, and more.

  > #### Deprecated {: .warning}
  >
  > One Call API 2.5 was deprecated in June 2024.
  > Please migrate to One Call API 3.0 which requires a separate
  > "One Call by Call" subscription.
  > See: https://openweathermap.org/api/one-call-3

  ## Examples

      iex> location = ExOwm.Location.by_coords(52.374031, 4.88969)
      iex> ExOwm.one_call(location, units: :metric)
      {:ok, %{"current" => %{"temp" => 15.2}, ...}}

  """
  @deprecated "One Call API 2.5 was deprecated in June 2024. Migrate to One Call API 3.0."
  @spec one_call(location(), options()) :: result()
  def one_call(location, opts \\ []) do
    Client.fetch(:one_call, location, opts)
  end

  @doc """
  Fetches One Call API data for multiple locations concurrently.

  > #### Deprecated {: .warning}
  >
  > One Call API 2.5 was deprecated in June 2024.
  > See `one_call/2` for more information.
  """
  @deprecated "One Call API 2.5 was deprecated in June 2024. Migrate to One Call API 3.0."
  @spec one_call_batch([location()], options()) :: batch_results()
  def one_call_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:one_call, locations, opts)
  end

  @doc """
  Fetches 5 day / 3 hour weather forecast.

  ## Examples

      iex> location = ExOwm.Location.by_city("Warsaw")
      iex> ExOwm.forecast_5day(location, units: :metric)
      {:ok, %{"list" => [%{"dt" => ..., "main" => %{"temp" => 15.2}}, ...]}}

  """
  @spec forecast_5day(location(), options()) :: result()
  def forecast_5day(location, opts \\ []) do
    Client.fetch(:forecast_5day, location, opts)
  end

  @doc """
  Fetches 5 day forecast for multiple locations concurrently.
  """
  @spec forecast_5day_batch([location()], options()) :: batch_results()
  def forecast_5day_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:forecast_5day, locations, opts)
  end

  @doc """
  Fetches 4 day hourly weather forecast.

  Note: This endpoint requires a paid OpenWeatherMap plan.

  ## Examples

      iex> location = ExOwm.Location.by_city("Warsaw")
      iex> ExOwm.forecast_hourly(location, units: :metric)
      {:ok, %{"list" => [...]}}

  """
  @spec forecast_hourly(location(), options()) :: result()
  def forecast_hourly(location, opts \\ []) do
    Client.fetch(:forecast_hourly, location, opts)
  end

  @doc """
  Fetches hourly forecast for multiple locations concurrently.
  """
  @spec forecast_hourly_batch([location()], options()) :: batch_results()
  def forecast_hourly_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:forecast_hourly, locations, opts)
  end

  @doc """
  Fetches 1-16 day daily weather forecast.

  Use the `:cnt` option to specify the number of days (1-16).

  ## Examples

      iex> location = ExOwm.Location.by_city("Warsaw")
      iex> ExOwm.forecast_16day(location, cnt: 16, units: :metric)
      {:ok, %{"list" => [...]}}

  """
  @spec forecast_16day(location(), options()) :: result()
  def forecast_16day(location, opts \\ []) do
    Client.fetch(:forecast_16day, location, opts)
  end

  @doc """
  Fetches 16 day forecast for multiple locations concurrently.
  """
  @spec forecast_16day_batch([location()], options()) :: batch_results()
  def forecast_16day_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:forecast_16day, locations, opts)
  end

  @doc """
  Fetches historical weather data.

  The location must include a timestamp (use `Location.with_timestamp/2`).
  Historical data is available for the last 5 days.

  > #### Deprecated {: .warning}
  >
  > One Call API 2.5 timemachine endpoint was deprecated in June 2024.
  > Please migrate to One Call API 3.0 which requires a separate
  > "One Call by Call" subscription.
  > See: https://openweathermap.org/api/one-call-3#history

  ## Examples

      iex> yesterday = System.system_time(:second) - 86400
      iex> location = ExOwm.Location.by_coords(52.37, 4.89) |> ExOwm.Location.with_timestamp(yesterday)
      iex> ExOwm.historical(location, units: :metric)
      {:ok, %{"current" => %{"temp" => 12.5}, ...}}

  """
  @deprecated "One Call API 2.5 timemachine was deprecated in June 2024. Migrate to One Call API 3.0."
  @spec historical(location(), options()) :: result()
  def historical(location, opts \\ []) do
    Client.fetch(:historical, location, opts)
  end

  @doc """
  Fetches historical weather data for multiple locations concurrently.

  > #### Deprecated {: .warning}
  >
  > One Call API 2.5 timemachine endpoint was deprecated in June 2024.
  > See `historical/2` for more information.
  """
  @deprecated "One Call API 2.5 timemachine was deprecated in June 2024. Migrate to One Call API 3.0."
  @spec historical_batch([location()], options()) :: batch_results()
  def historical_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:historical, locations, opts)
  end

  @doc """
  Fetches current air pollution data for a location.

  Returns Air Quality Index and concentrations of pollutants:
  CO, NO, NO2, O3, SO2, NH3, PM2.5, and PM10.

  ## Examples

      iex> location = ExOwm.Location.by_coords(52.374031, 4.88969)
      iex> ExOwm.air_pollution(location)
      {:ok, %{"list" => [%{"main" => %{"aqi" => 2}, "components" => %{...}}]}}

  """
  @spec air_pollution(location(), options()) :: result()
  def air_pollution(location, opts \\ []) do
    Client.fetch(:air_pollution, location, opts)
  end

  @doc """
  Fetches air pollution data for multiple locations concurrently.
  """
  @spec air_pollution_batch([location()], options()) :: batch_results()
  def air_pollution_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:air_pollution, locations, opts)
  end

  @doc """
  Fetches air pollution forecast for 4 days with 1-hour step.

  ## Examples

      iex> location = ExOwm.Location.by_coords(52.374031, 4.88969)
      iex> ExOwm.air_pollution_forecast(location)
      {:ok, %{"list" => [%{"dt" => ..., "main" => %{"aqi" => 1}, ...}]}}

  """
  @spec air_pollution_forecast(location(), options()) :: result()
  def air_pollution_forecast(location, opts \\ []) do
    Client.fetch(:air_pollution_forecast, location, opts)
  end

  @doc """
  Fetches air pollution forecast for multiple locations concurrently.
  """
  @spec air_pollution_forecast_batch([location()], options()) :: batch_results()
  def air_pollution_forecast_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:air_pollution_forecast, locations, opts)
  end

  @doc """
  Fetches historical air pollution data for a time range.

  Requires `start` and `end` Unix timestamps in options.

  ## Examples

      iex> now = System.system_time(:second)
      iex> yesterday = now - 86400
      iex> location = ExOwm.Location.by_coords(52.374031, 4.88969)
      iex> ExOwm.air_pollution_history(location, start: yesterday, end: now)
      {:ok, %{"list" => [...]}}

  """
  @spec air_pollution_history(location(), options()) :: result()
  def air_pollution_history(location, opts \\ []) do
    Client.fetch(:air_pollution_history, location, opts)
  end

  @doc """
  Fetches historical air pollution data for multiple locations concurrently.
  """
  @spec air_pollution_history_batch([location()], options()) :: batch_results()
  def air_pollution_history_batch(locations, opts \\ []) when is_list(locations) do
    Client.fetch_batch(:air_pollution_history, locations, opts)
  end

  @doc """
  Geocodes a location query to coordinates.

  Returns a list of matching locations with lat/lon coordinates.

  ## Parameters

    * `query` - City name, optionally with state code and country code (e.g., "London", "London,GB", "London,Ontario,CA")
    * `opts` - Options including `:limit` (default: 5, max results)

  ## Examples

      iex> ExOwm.geocode("London", limit: 5)
      {:ok, [%{"name" => "London", "lat" => 51.5073219, "lon" => -0.1276474, "country" => "GB"}, ...]}

      iex> ExOwm.geocode("Warsaw,PL")
      {:ok, [%{"name" => "Warsaw", "lat" => 52.2319581, "lon" => 21.0067249, ...}]}

  """
  @spec geocode(String.t(), options()) :: result()
  def geocode(query, opts \\ []) when is_binary(query) do
    location = %Location{type: :geocode_query, query: query}
    Client.fetch(:geocode, location, Keyword.put(opts, :q, query))
  end

  @doc """
  Reverse geocodes coordinates to location names.

  Returns a list of locations at or near the given coordinates.

  ## Parameters

    * `lat` - Latitude
    * `lon` - Longitude
    * `opts` - Options including `:limit` (default: 5, max results)

  ## Examples

      iex> ExOwm.reverse_geocode(52.374031, 4.88969, limit: 1)
      {:ok, [%{"name" => "Amsterdam", "lat" => 52.374031, "lon" => 4.88969, ...}]}

  """
  @spec reverse_geocode(float(), float(), options()) :: result()
  def reverse_geocode(lat, lon, opts \\ []) when is_number(lat) and is_number(lon) do
    location = Location.by_coords(lat, lon)
    Client.fetch(:reverse_geocode, location, opts)
  end

  # ============================================================================
  # Deprecated API (v1.x compatibility)
  # ============================================================================

  @deprecated "Use ExOwm.current_weather/2 or ExOwm.current_weather_batch/2 instead"
  @doc false
  def get_current_weather(locations, opts \\ [])

  def get_current_weather(locations, opts) when is_list(locations) do
    current_weather_batch(locations, opts)
  end

  def get_current_weather(location, opts) when is_map(location) do
    [current_weather(location, opts)]
  end

  @deprecated "Use ExOwm.one_call/2 or ExOwm.one_call_batch/2 instead"
  @doc false
  def get_weather(locations, opts \\ [])

  def get_weather(locations, opts) when is_list(locations) do
    one_call_batch(locations, opts)
  end

  def get_weather(location, opts) when is_map(location) do
    [one_call(location, opts)]
  end

  @deprecated "Use ExOwm.forecast_5day/2 or ExOwm.forecast_5day_batch/2 instead"
  @doc false
  def get_five_day_forecast(locations, opts \\ [])

  def get_five_day_forecast(locations, opts) when is_list(locations) do
    forecast_5day_batch(locations, opts)
  end

  def get_five_day_forecast(location, opts) when is_map(location) do
    [forecast_5day(location, opts)]
  end

  @deprecated "Use ExOwm.forecast_hourly/2 or ExOwm.forecast_hourly_batch/2 instead"
  @doc false
  def get_hourly_forecast(locations, opts \\ [])

  def get_hourly_forecast(locations, opts) when is_list(locations) do
    forecast_hourly_batch(locations, opts)
  end

  def get_hourly_forecast(location, opts) when is_map(location) do
    [forecast_hourly(location, opts)]
  end

  @deprecated "Use ExOwm.forecast_16day/2 or ExOwm.forecast_16day_batch/2 instead"
  @doc false
  def get_sixteen_day_forecast(locations, opts \\ [])

  def get_sixteen_day_forecast(locations, opts) when is_list(locations) do
    forecast_16day_batch(locations, opts)
  end

  def get_sixteen_day_forecast(location, opts) when is_map(location) do
    [forecast_16day(location, opts)]
  end

  @deprecated "Use ExOwm.historical/2 or ExOwm.historical_batch/2 instead"
  @doc false
  def get_historical_weather(locations, opts \\ [])

  def get_historical_weather(locations, opts) when is_list(locations) do
    historical_batch(locations, opts)
  end

  def get_historical_weather(location, opts) when is_map(location) do
    [historical(location, opts)]
  end
end
