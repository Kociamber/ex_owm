defmodule ExOwm.HourlyForecast.Worker do
  @moduledoc """
  Five Day Forecast Worker task implementation.
  """
  alias ExOwm.Api
  alias ExOwm.Cache

  @doc """
  Returns five day weather forecast for a specific location and given options.
  Checks whether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_hourly_forecast(map, key: atom) :: map
  def get_hourly_forecast(location, opts) do
    case Cache.get("hourly_forecast: #{inspect(location)}") do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_hourly_forecast, location, opts)
        Cache.put("hourly_forecast: #{inspect(location)}", result, ttl: :timer.minutes(10))
        result

      # If location was cached, return it
      location ->
        location
    end
  end
end
