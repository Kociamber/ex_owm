# Changelog

## 2.0.0 - 22-01-2026

Major breaking release with significant architectural improvements and API changes. See [UPGRADE.md](UPGRADE.md) for migration guide.

### Added

New weather and forecast APIs: `current_weather`, `one_call`, `forecast_5day`, `forecast_hourly`, `forecast_16day`, `historical`

Air quality APIs with pollution data and forecasts: `air_pollution`, `air_pollution_forecast`, `air_pollution_history`

Geocoding APIs to convert between location names and coordinates: `geocode`, `reverse_geocode`

Explicit batch functions with `*_batch` suffix for concurrent multi-location requests

Location validation via `ExOwm.Location` module with constructors: `by_city`, `by_coords`, `by_id`, `by_zip`

Telemetry support with `[:ex_owm, :request, :start]` and `[:ex_owm, :request, :stop]` events

Configurable cache TTL per endpoint with per-request overrides

Optional caching - can be disabled via `:cache_enabled` config (enabled by default)

Modern HTTP client using Req instead of HTTPoison for better retry and telemetry

Consistent error tuples with detailed feedback

Upgrade guide in UPGRADE.md with migration examples

### Changed

Breaking changes:

`get_weather` renamed to `one_call` for API clarity

Single location requests return `{:ok, data}` instead of `[{:ok, data}]`

Batch requests require explicit `*_batch` function calls

All Coordinator GenServers removed - simplified to direct function calls

Worker modules unified into `ExOwm.Client`

HTTPoison replaced with Req

Improvements:

Error tuples are now consistent (always 2 or 3 elements)

Location maps still work but `ExOwm.Location` constructors recommended

Simplified supervision tree - only Cache supervised

Removed ~400 lines of code for better maintainability

### Deprecated

Old v1.x function names (will be removed in v3.0.0):

`get_current_weather/2` - Use `current_weather/2` or `current_weather_batch/2`

`get_weather/2` - Use `one_call/2` or `one_call_batch/2`

`get_five_day_forecast/2` - Use `forecast_5day/2` or `forecast_5day_batch/2`

`get_hourly_forecast/2` - Use `forecast_hourly/2` or `forecast_hourly_batch/2`

`get_sixteen_day_forecast/2` - Use `forecast_16day/2` or `forecast_16day_batch/2`

`get_historical_weather/2` - Use `historical/2` or `historical_batch/2`

OpenWeatherMap deprecated APIs:

`one_call/2` and `one_call_batch/2` - One Call API 2.5 deprecated by OpenWeatherMap in June 2024. Consider using specific endpoint APIs instead.

`historical/2` and `historical_batch/2` - Historical data via One Call API 2.5 deprecated. Use `air_pollution_history` for air quality historical data.

All deprecated functions currently work with deprecation warnings.

### Removed

`ExOwm.Supervisor` module - replaced by inline supervision in Application

All `ExOwm.*Weather.Coordinator` modules - 6 GenServers removed

All `ExOwm.*Weather.Worker` modules - 6 modules removed

`ExOwm.WorkerHelper` module - functionality moved to Client

Direct GenServer access - use main ExOwm module functions

### Migration Path

**Minimal changes** (keep using deprecated API):
```elixir
# Your v1.x code continues to work with deprecation warnings
ExOwm.get_current_weather([%{city: "Warsaw"}])
# => Warning: deprecated, use current_weather_batch instead
```

**Recommended migration**:
```elixir
# Before
ExOwm.get_current_weather([%{city: "Warsaw"}], units: :metric)
# => [{:ok, data}]

# After
location = ExOwm.Location.by_city("Warsaw")
ExOwm.current_weather(location, units: :metric)
# => {:ok, data}
```

See [UPGRADE.md](UPGRADE.md) for complete migration guide with all patterns.

### Technical Details

**Architecture Changes:**
- Removed 6 stateless Coordinator GenServers that added no value
- Removed 6 duplicate Worker modules (240 lines of duplicated code)
- Unified request logic into single `ExOwm.Client` module
- Direct Task.async_stream for concurrent requests (no GenServer indirection)
- Simplified supervision tree from 7 processes to 1 (Cache)

**Dependencies:**
- Added: `req ~> 0.5` (modern HTTP client)
- Added: `telemetry ~> 1.0` (observability)
- Removed: `httpoison` (replaced by Req)

**Performance:**
- Reduced process overhead (no unnecessary GenServer serialization)
- Better concurrent request handling with Task.async_stream
- Smart default TTL per endpoint type
- Maintained backward compatibility for smooth migration

---

### 1.1.1 - 16-12-2018
### Added
    - Formatter and changelog files.
### Modified
    - Split coordinator into separate GenServer processes.
    - Re-factor and re-name main modules.
    - Format whole project.
