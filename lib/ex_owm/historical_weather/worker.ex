defmodule ExOwm.HistoricalWeather.Worker do
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
  @spec get_historical_weather(map, key: atom) :: map
  def get_historical_weather(location, opts) do
    case Cache.get("historical_weather: #{inspect(location)}") do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_historical_weather, location, opts)

        # TODO: can we increase this ttl based on the current time? Because it always returns the whole day.
        Cache.put("historical_weather: #{inspect(location)}", result, ttl: :timer.minutes(10))
        result

      # If location was cached, return it
      location ->
        location
    end
  end
end
