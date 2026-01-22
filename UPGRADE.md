# Upgrading to v2.0

ExOwm v2.0 is a major refactor with breaking changes. Your v1.x code will still work with deprecation warnings, but you should migrate to the new API for better performance and cleaner code.

## Quick Migration

If you just want to get rid of deprecation warnings with minimal changes, replace the old function names:

```elixir
# Old v1.x functions -> New v2.0 functions
get_current_weather     -> current_weather / current_weather_batch
get_weather             -> one_call / one_call_batch  
get_five_day_forecast   -> forecast_5day / forecast_5day_batch
get_hourly_forecast     -> forecast_hourly / forecast_hourly_batch
get_sixteen_day_forecast -> forecast_16day / forecast_16day_batch
get_historical_weather  -> historical / historical_batch
```

## Return Value Changes

Single location requests now return `{:ok, data}` instead of `[{:ok, data}]`:

```elixir
# v1.x - always returns a list
ExOwm.get_current_weather([%{city: "Warsaw"}])
# => [{:ok, data}]

# v2.0 - single location returns tuple
ExOwm.current_weather(%{city: "Warsaw"})
# => {:ok, data}

# v2.0 - batch returns list
ExOwm.current_weather_batch([%{city: "Warsaw"}])
# => [{:ok, data}]
```

Pattern matching update:

```elixir
# v1.x
case ExOwm.get_current_weather([location]) do
  [{:ok, data}] -> handle_success(data)
  [{:error, reason}] -> handle_error(reason)
end

# v2.0
case ExOwm.current_weather(location) do
  {:ok, data} -> handle_success(data)
  {:error, reason} -> handle_error(reason)
end
```

## Location Validation (Recommended)

Use `ExOwm.Location` constructors for type safety and validation:

```elixir
# Old style - maps (still works)
location = %{city: "Warsaw", country_code: "pl"}

# New style - validated constructors
location = ExOwm.Location.by_city("Warsaw", country: "pl")
location = ExOwm.Location.by_coords(52.374031, 4.88969)
location = ExOwm.Location.by_id(2759794)
location = ExOwm.Location.by_zip("94040", country: "us")
```

Benefits:

Raises `ArgumentError` immediately if coordinates are invalid (lat not in [-90, 90], lon not in [-180, 180])

Validates required fields (e.g., ZIP code requires country)

Type-safe and self-documenting

## Batch Requests

Explicit `*_batch` functions for multiple locations:

```elixir
# v1.x - implicit batch
locations = [%{city: "Warsaw"}, %{city: "London"}]
results = ExOwm.get_current_weather(locations)
# => [{:ok, data1}, {:ok, data2}]

# v2.0 - explicit batch function
locations = [
  ExOwm.Location.by_city("Warsaw"),
  ExOwm.Location.by_city("London")
]
results = ExOwm.current_weather_batch(locations)
# => [{:ok, data1}, {:ok, data2}]
```

## Error Handling

Error tuples are now consistent:

```elixir
# v2.0 errors
{:ok, data}                           # Success
{:error, :not_found}                  # Simple error
{:error, :api_key_invalid, details}   # Error with details
{:error, :request_failed, reason}     # HTTP error
```

Handle errors properly:

```elixir
case ExOwm.current_weather(location) do
  {:ok, data} -> 
    process_weather(data)
    
  {:error, :not_found, details} -> 
    Logger.warning("Location not found: #{inspect(details)}")
    
  {:error, :api_key_invalid, _} -> 
    Logger.error("Invalid API key configured")
    
  {:error, reason} -> 
    Logger.error("Request failed: #{inspect(reason)}")
end
```

## Configuration

No configuration changes needed. Same as v1.x:

```elixir
config :ex_owm, api_key: System.get_env("OWM_API_KEY")

# Optional cache TTL per endpoint
config :ex_owm, :default_ttl, :timer.minutes(10)
config :ex_owm, :current_weather_ttl, :timer.minutes(5)
```

Override TTL per request:

```elixir
ExOwm.current_weather(location, ttl: :timer.minutes(1))
```

## Dependency Changes

Update your `mix.exs`:

```elixir
defp deps do
  [
    {:ex_owm, "~> 2.0"}
  ]
end
```

Run `mix deps.update ex_owm` to pull new dependencies:

HTTPoison removed, Req added (handles retries and telemetry better)

Telemetry added for observability

## New Features in v2.0

Air quality APIs:

```elixir
location = ExOwm.Location.by_coords(52.37, 4.89)

{:ok, data} = ExOwm.air_pollution(location)
{:ok, forecast} = ExOwm.air_pollution_forecast(location)

now = System.system_time(:second)
yesterday = now - 86_400
{:ok, history} = ExOwm.air_pollution_history(location, start: yesterday, end: now)
```

Geocoding APIs:

```elixir
# Name to coordinates
{:ok, locations} = ExOwm.geocode("London", limit: 5)
{:ok, [location]} = ExOwm.geocode("London,GB", limit: 1)

# Coordinates to name
{:ok, locations} = ExOwm.reverse_geocode(52.374031, 4.88969, limit: 1)
```

Telemetry integration:

```elixir
:telemetry.attach_many(
  "owm-handler",
  [
    [:ex_owm, :request, :start],
    [:ex_owm, :request, :stop]
  ],
  &MyApp.handle_owm_event/4,
  nil
)
```

## Deprecated APIs

One Call API 2.5 was deprecated by OpenWeatherMap in June 2024:

```elixir
# These still work but emit deprecation warnings
ExOwm.one_call(location)           # One Call 2.5 deprecated
ExOwm.historical(location)         # Part of One Call 2.5

# Consider using specific endpoint APIs instead
ExOwm.current_weather(location)    # Current weather only
ExOwm.forecast_5day(location)      # 5-day forecast
ExOwm.air_pollution_history(location, start: ts, end: ts)  # Air quality history
```

## Complete Migration Example

Before (v1.x):

```elixir
defmodule MyApp.Weather do
  def get_weather(city) do
    case ExOwm.get_current_weather([%{city: city}], units: :metric) do
      [{:ok, data}] -> 
        {:ok, extract_temp(data)}
      [{:error, reason}] -> 
        {:error, reason}
    end
  end
  
  defp extract_temp(data) do
    data["main"]["temp"]
  end
end
```

After (v2.0):

```elixir
defmodule MyApp.Weather do
  def get_weather(city) do
    location = ExOwm.Location.by_city(city)
    
    case ExOwm.current_weather(location, units: :metric) do
      {:ok, data} -> 
        {:ok, extract_temp(data)}
      {:error, reason} -> 
        {:error, reason}
    end
  end
  
  defp extract_temp(data) do
    data["main"]["temp"]
  end
end
```

## Breaking Changes Summary

Function names changed (old ones deprecated)

Single location requests return `{:ok, data}` not `[{:ok, data}]`

Batch requests require explicit `*_batch` functions

HTTPoison replaced with Req

GenServer coordinators and workers removed

`ExOwm.Supervisor` module removed

Direct GenServer calls no longer supported (use ExOwm module functions)

## Need Help?

Check the [README](README.md) for full documentation

See [CHANGELOG](CHANGELOG.md) for complete list of changes

Open an issue on GitHub if you encounter problems
