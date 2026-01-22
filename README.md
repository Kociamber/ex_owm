# ExOwm

[![Hex Version](https://img.shields.io/hexpm/v/ex_owm.svg)](https://hex.pm/packages/ex_owm)
[![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/ex_owm/)
[![License](https://img.shields.io/hexpm/l/ex_owm.svg)](https://github.com/kociamber/ex_owm/blob/master/LICENSE)
[![Total Download](https://img.shields.io/hexpm/dt/ex_owm.svg)](https://hex.pm/packages/ex_owm)
[![Last Updated](https://img.shields.io/github/last-commit/kociamber/ex_owm.svg)](https://github.com/kociamber/ex_owm/commits/master)

**Modern, fast [OpenWeatherMap](http://openweathermap.org/technology) API client for Elixir applications.**

## Features

Clean, intuitive API with validated location types

Concurrent requests with automatic batching

Smart caching with configurable TTL per endpoint

Telemetry integration for production observability

Modern dependencies (Req, Nebulex)

Comprehensive error handling with detailed feedback

## Installation

Add ExOwm as a dependency to your `mix.exs` file:

```elixir
defp deps() do
  [
    {:ex_owm, "~> 2.0"}
  ]
end
```

## Upgrading from 1.x?

See [UPGRADE.md](UPGRADE.md) for a comprehensive migration guide. The v1.x API still works with deprecation warnings.

## Configuration

To use OWM APIs, you need to [register](https://home.openweathermap.org/users/sign_up) for an account (free plan is available) and obtain an API key.

Add the following configuration to your `config/config.exs` file:

```elixir
config :ex_owm, api_key: System.get_env("OWM_API_KEY")

# Optional: Disable caching (enabled by default)
config :ex_owm, :cache_enabled, false

# Optional: Configure cache TTL per endpoint (when cache is enabled)
config :ex_owm, :default_ttl, :timer.minutes(10)
config :ex_owm, :current_weather_ttl, :timer.minutes(5)
config :ex_owm, :forecast_5day_ttl, :timer.hours(1)
```

## Quick Start

### Basic Usage

```elixir
# Using validated location constructors (recommended)
location = ExOwm.Location.by_city("Warsaw")
{:ok, weather} = ExOwm.current_weather(location, units: :metric)

# Using raw maps (backward compatible)
{:ok, weather} = ExOwm.current_weather(%{city: "Warsaw"}, units: :metric)

# Multiple location types
location = ExOwm.Location.by_city("London", country: "uk")
location = ExOwm.Location.by_coords(52.374031, 4.88969)
location = ExOwm.Location.by_id(2759794)
location = ExOwm.Location.by_zip("94040", country: "us")
```

### Batch Requests

```elixir
locations = [
  ExOwm.Location.by_city("Warsaw"),
  ExOwm.Location.by_city("London", country: "uk"),
  ExOwm.Location.by_coords(52.374031, 4.88969)
]

results = ExOwm.current_weather_batch(locations, units: :metric, lang: :pl)
# => [
#   {:ok, %{"name" => "Warszawa", ...}},
#   {:ok, %{"name" => "London", ...}},
#   {:ok, %{"name" => "Amsterdam", ...}}
# ]
```

### Error Handling

```elixir
location = ExOwm.Location.by_city("InvalidCity")

case ExOwm.current_weather(location) do
  {:ok, data} -> 
    IO.inspect(data)
  
  {:error, :not_found, details} -> 
    IO.puts("City not found: #{inspect(details)}")
  
  {:error, :api_key_invalid, _} -> 
    IO.puts("Invalid API key")
  
  {:error, reason} -> 
    IO.puts("Request failed: #{inspect(reason)}")
end
```

## Available Endpoints

ExOwm supports the following OpenWeatherMap [APIs](http://openweathermap.org/api):

### Weather Data

#### Current Weather
```elixir
# Single location
ExOwm.current_weather(location, units: :metric)

# Batch
ExOwm.current_weather_batch(locations, units: :metric)
```

#### One Call API
Includes current weather, minute/hourly/daily forecasts, and historical data in one call.

```elixir
# Requires coordinates
location = ExOwm.Location.by_coords(52.374031, 4.88969)
ExOwm.one_call(location, units: :metric)

# Batch
ExOwm.one_call_batch(locations, units: :metric)
```

#### 5 Day / 3 Hour Forecast
```elixir
ExOwm.forecast_5day(location, units: :metric)
ExOwm.forecast_5day_batch(locations, units: :metric)
```

#### 4 Day Hourly Forecast
**Note:** Requires paid OpenWeatherMap plan.

```elixir
ExOwm.forecast_hourly(location, units: :metric)
ExOwm.forecast_hourly_batch(locations, units: :metric)
```

#### 1-16 Day Daily Forecast
```elixir
ExOwm.forecast_16day(location, cnt: 16, units: :metric)
ExOwm.forecast_16day_batch(locations, cnt: 16, units: :metric)
```

#### Historical Weather Data
Available for the last 5 days.

```elixir
yesterday = System.system_time(:second) - 86400

location = 
  ExOwm.Location.by_coords(52.374031, 4.88969)
  |> ExOwm.Location.with_timestamp(yesterday)

ExOwm.historical(location, units: :metric)
```

### Air Quality

#### Current Air Pollution
Get current air quality index and pollutant concentrations (CO, NO, NO2, O3, SO2, NH3, PM2.5, PM10).

```elixir
location = ExOwm.Location.by_coords(52.374031, 4.88969)
{:ok, data} = ExOwm.air_pollution(location)

# AQI scale: 1 = Good, 2 = Fair, 3 = Moderate, 4 = Poor, 5 = Very Poor
aqi = get_in(data, ["list", Access.at(0), "main", "aqi"])

ExOwm.air_pollution_batch(locations)
```

#### Air Pollution Forecast
Four-day hourly forecast of air quality.

```elixir
ExOwm.air_pollution_forecast(location)
ExOwm.air_pollution_forecast_batch(locations)
```

#### Historical Air Pollution
Historical air quality data from November 27, 2020 onwards.

```elixir
now = System.system_time(:second)
yesterday = now - 86_400

ExOwm.air_pollution_history(location, start: yesterday, end: now)
ExOwm.air_pollution_history_batch(locations, start: yesterday, end: now)
```

### Geocoding

#### Direct Geocoding
Convert location names to coordinates.

```elixir
{:ok, locations} = ExOwm.geocode("London", limit: 5)
{:ok, locations} = ExOwm.geocode("London,GB", limit: 1)

# Returns: [%{"name" => "London", "lat" => 51.5074, "lon" => -0.1278, "country" => "GB"}]
```

#### Reverse Geocoding
Convert coordinates to location names.

```elixir
{:ok, locations} = ExOwm.reverse_geocode(52.374031, 4.88969, limit: 1)

# Returns: [%{"name" => "Amsterdam", "lat" => 52.374031, "lon" => 4.88969, "country" => "NL"}]
```

## Request Options

Weather APIs:

`:units` - `:metric`, `:imperial`, or `:standard` (default Kelvin)

`:lang` - Language code as atom (`:pl`, `:en`, `:ru`, `:de`)

`:cnt` - Number of forecast days for 16-day forecast (1-16)

`:ttl` - Cache TTL in milliseconds (overrides default)

Geocoding APIs:

`:limit` - Max results (default 5)

Air pollution history:

`:start` - Start timestamp (Unix time, UTC)

`:end` - End timestamp (Unix time, UTC)

## Telemetry

ExOwm emits telemetry events for observability:

```elixir
# In your application.ex
:telemetry.attach_many(
  "ex-owm-handler",
  [
    [:ex_owm, :request, :start],
    [:ex_owm, :request, :stop]
  ],
  &MyApp.Telemetry.handle_owm_event/4,
  nil
)

defmodule MyApp.Telemetry do
  require Logger

  def handle_owm_event([:ex_owm, :request, :stop], measurements, metadata, _) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    
    Logger.info("OpenWeatherMap API call completed",
      endpoint: metadata.endpoint,
      cache: metadata.cache,
      duration_ms: duration_ms
    )
  end

  def handle_owm_event([:ex_owm, :request, :start], _, _, _), do: :ok
end
```

### Event Metadata

**`[:ex_owm, :request, :start]`:**
- `endpoint` - API endpoint (`:current_weather`, `:one_call`, etc.)
- `location` - Location struct or map
- `cache` - `:hit` or `:miss`

**`[:ex_owm, :request, :stop]`:**
- All metadata from `:start` event
- `result` - The API result tuple
- `duration` - Request duration (native time units in measurements)

## Caching

ExOwm includes optional built-in caching using [Nebulex](https://github.com/cabol/nebulex). Caching is enabled by default to reduce API costs and improve response times.

**Disable caching:**
```elixir
config :ex_owm, :cache_enabled, false
```

**Default TTL by endpoint:**
- `current_weather`: 10 minutes
- `one_call`: 10 minutes
- `forecast_5day`: 1 hour
- `forecast_hourly`: 1 hour
- `forecast_16day`: 6 hours
- `historical`: 24 hours

**Override in config:**
```elixir
config :ex_owm, :default_ttl, :timer.minutes(10)
config :ex_owm, :current_weather_ttl, :timer.minutes(5)
```

**Override per-request:**
```elixir
ExOwm.current_weather(location, ttl: :timer.minutes(1))
```

When caching is disabled, all requests go directly to the OpenWeatherMap API without any caching layer.

## Location Validation

Use `ExOwm.Location` constructors for early validation:

```elixir
# City - validates non-empty string
location = ExOwm.Location.by_city("Warsaw")
location = ExOwm.Location.by_city("London", country: "uk")

# Coordinates - validates lat/lon ranges
location = ExOwm.Location.by_coords(52.374031, 4.88969)
# Raises ArgumentError if lat not in [-90, 90] or lon not in [-180, 180]

# City ID - validates positive integer
location = ExOwm.Location.by_id(2759794)

# ZIP code - requires country parameter
location = ExOwm.Location.by_zip("94040", country: "us")

# Add timestamp for historical queries
location = 
  ExOwm.Location.by_coords(52.37, 4.89)
  |> ExOwm.Location.with_timestamp(1615546800)
```

## Running Tests

Tests require a valid OpenWeatherMap API key and are disabled by default:

```bash
# Set your API key
export OWM_API_KEY="your_key_here"

# Remove the :api_based_test exclusion in test/test_helper.exs
# Then run tests
mix test
```

## Architecture

ExOwm v2.0 uses a simplified architecture:

- **No coordinator GenServers** - Direct function calls with `Task.async_stream` for batching
- **Smart caching** - Nebulex with Shards backend
- **Modern HTTP** - Req client with built-in retry/telemetry support
- **Telemetry events** - Full observability for production monitoring

This results in **~400 fewer lines** of code compared to v1.x while being more maintainable and performant.

## API Limitations

Please note that with a standard (free) license/API key, you may be limited in:
- Number of requests per minute (60 calls/minute for free tier)
- Access to certain endpoints (hourly forecast, 16-day forecast)

Refer to OpenWeatherMap [pricing plans](http://openweathermap.org/price) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is MIT licensed. Please see the [`LICENSE.md`](https://github.com/Kociamber/ex_owm/blob/master/LICENSE.md) file for more details.
