defmodule ExOwm.SixteenDayForecast.Worker do
  @moduledoc """
  Sixteen Day Forecast Worker task implementation.
  """
  alias ExOwm.Api
  alias ExOwm.SixteenDayForecast.Cache

  @doc """
  Returns sixteen day weather forecast for a specific location and given options.
  Checks wether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_sixteen_day_forecast(map, key: atom) :: map
  def get_sixteen_day_forecast(location, opts) do
    case Cache.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_sixteen_day_forecast, location, opts)
        Cache.set(location, result, ttl: :infinity)

      # If location was cached, return it
      location ->
        location
    end
  end
end
