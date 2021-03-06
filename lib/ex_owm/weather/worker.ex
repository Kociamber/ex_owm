defmodule ExOwm.Weather.Worker do
  @moduledoc """
  Current Weather Worker task implementation.
  """
  alias ExOwm.Api
  alias ExOwm.Cache

  @doc """
  Returns current weather for a specific location and given options.
  Checks whether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_weather(map, key: atom) :: map
  def get_weather(location, opts) do
    case Cache.get("one_call: #{inspect(location)}") do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_weather, location, opts)
        Cache.put("one_call: #{inspect(location)}", result, ttl: :timer.minutes(10))
        result

      # If location was cached, return it
      location ->
        location
    end
  end
end
