defmodule ExOwm.Client do
  @moduledoc """
  Unified client for making OpenWeatherMap API requests.

  This module replaces the old Coordinator/Worker pattern with a simpler
  approach using direct function calls and Task.async_stream for batching.
  """

  alias ExOwm.{Api, Location}

  @type endpoint ::
          :current_weather
          | :one_call
          | :forecast_5day
          | :forecast_hourly
          | :forecast_16day
          | :historical
          | :air_pollution
          | :air_pollution_forecast
          | :air_pollution_history
          | :geocode
          | :reverse_geocode

  @type options :: keyword()
  @type result :: {:ok, map()} | {:error, term()} | {:error, term(), term()}

  @doc """
  Fetches weather data for a single location.

  ## Parameters

    * `endpoint` - The API endpoint to call (`:current_weather`, `:one_call`, etc.)
    * `location` - A `%ExOwm.Location{}` struct or location map
    * `opts` - Request options (units, lang, cnt, etc.)

  ## Returns

    * `{:ok, data}` - Successfully fetched weather data
    * `{:error, reason}` - API error (not_found, bad_request, etc.)
    * `{:error, reason, details}` - API error with response details

  """
  @spec fetch(endpoint(), Location.t() | map(), options()) :: result()
  def fetch(endpoint, location, opts \\ [])

  def fetch(endpoint, %Location{} = location, opts) do
    api_type = endpoint_to_api_type(endpoint)
    metadata = %{endpoint: endpoint, location: location}

    if cache_enabled?() do
      fetch_with_cache(endpoint, api_type, location, opts, metadata)
    else
      fetch_without_cache(api_type, location, opts, metadata)
    end
  end

  def fetch(endpoint, location_map, opts) when is_map(location_map) do
    location = Location.from_map(location_map)
    fetch(endpoint, location, opts)
  end

  @doc """
  Fetches weather data for multiple locations concurrently.

  ## Parameters

    * `endpoint` - The API endpoint to call
    * `locations` - List of `%ExOwm.Location{}` structs or location maps
    * `opts` - Request options

  ## Returns

  List of results, each being `{:ok, data}` or `{:error, reason}`.

  """
  @spec fetch_batch(endpoint(), [Location.t() | map()], options()) :: [result()]
  def fetch_batch(endpoint, locations, opts \\ []) do
    locations
    |> Task.async_stream(
      fn location -> fetch(endpoint, location, opts) end,
      max_concurrency: System.schedulers_online() * 2,
      timeout: 30_000
    )
    |> Enum.map(fn
      {:ok, result} -> result
      {:exit, reason} -> {:error, {:task_exit, reason}}
    end)
  end

  @doc false
  @spec endpoint_to_api_type(endpoint()) :: atom()
  def endpoint_to_api_type(:current_weather), do: :get_current_weather
  def endpoint_to_api_type(:one_call), do: :get_weather
  def endpoint_to_api_type(:forecast_5day), do: :get_five_day_forecast
  def endpoint_to_api_type(:forecast_hourly), do: :get_hourly_forecast
  def endpoint_to_api_type(:forecast_16day), do: :get_sixteen_day_forecast
  def endpoint_to_api_type(:historical), do: :get_historical_weather
  def endpoint_to_api_type(:air_pollution), do: :get_air_pollution
  def endpoint_to_api_type(:air_pollution_forecast), do: :get_air_pollution_forecast
  def endpoint_to_api_type(:air_pollution_history), do: :get_air_pollution_history
  def endpoint_to_api_type(:geocode), do: :geocode_direct
  def endpoint_to_api_type(:reverse_geocode), do: :geocode_reverse

  defp cache_enabled? do
    Application.get_env(:ex_owm, :cache_enabled, true)
  end

  defp fetch_with_cache(endpoint, api_type, location, opts, metadata) do
    ttl = get_ttl(endpoint, opts)
    cache_key = build_cache_key(endpoint, location)

    case ExOwm.Cache.get(cache_key) do
      nil ->
        emit_telemetry_start(metadata, :miss)
        {result, duration} = execute_request(api_type, location, opts)
        emit_telemetry_stop(metadata, result, duration)
        ExOwm.Cache.put(cache_key, result, ttl: ttl)
        result

      cached_result ->
        emit_telemetry_start(metadata, :hit)
        cached_result
    end
  end

  defp fetch_without_cache(api_type, location, opts, metadata) do
    emit_telemetry_start(metadata, :disabled)
    {result, duration} = execute_request(api_type, location, opts)
    emit_telemetry_stop(metadata, result, duration)
    result
  end

  defp build_cache_key(endpoint, location) do
    "#{endpoint}:#{inspect(location)}"
  end

  defp execute_request(api_type, location, opts) do
    start_time = System.monotonic_time()
    result = Api.send_and_parse_request(api_type, location, opts)
    duration = System.monotonic_time() - start_time
    {result, duration}
  end

  defp emit_telemetry_start(metadata, cache_status) do
    :telemetry.execute(
      [:ex_owm, :request, :start],
      %{system_time: System.system_time()},
      Map.put(metadata, :cache, cache_status)
    )
  end

  defp emit_telemetry_stop(metadata, result, duration) do
    :telemetry.execute(
      [:ex_owm, :request, :stop],
      %{duration: duration},
      metadata |> Map.put(:cache, :miss) |> Map.put(:result, result)
    )
  end

  defp get_ttl(endpoint, opts) do
    Keyword.get(opts, :ttl) || default_ttl(endpoint)
  end

  defp default_ttl(endpoint) do
    config_key = :"#{endpoint}_ttl"

    Application.get_env(:ex_owm, config_key) ||
      Application.get_env(:ex_owm, :default_ttl) ||
      default_ttl_by_endpoint(endpoint)
  end

  defp default_ttl_by_endpoint(:current_weather), do: :timer.minutes(10)
  defp default_ttl_by_endpoint(:one_call), do: :timer.minutes(10)
  defp default_ttl_by_endpoint(:forecast_5day), do: :timer.hours(1)
  defp default_ttl_by_endpoint(:forecast_hourly), do: :timer.hours(1)
  defp default_ttl_by_endpoint(:forecast_16day), do: :timer.hours(6)
  defp default_ttl_by_endpoint(:historical), do: :timer.hours(24)
  defp default_ttl_by_endpoint(_), do: :timer.minutes(10)
end
