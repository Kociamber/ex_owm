defmodule ExOwm.Worker do
  @moduledoc """
  Module's code is executed as Elixir Task.
  """
  alias ExOwm.Api
  alias ExOwm.Cache

  @doc """
  Returns current weather for a specific location and given options.
  Checks wether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_current_weather(map, key: atom) :: map
  def get_current_weather(location, opts) do
    case Cache.CurrentWeather.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_current_weather, location, opts)
        Cache.CurrentWeather.set(location, result, ttl: :infinity)

      # If location was cached, return it
      location ->
        location
    end
  end

  @doc """
  Returns five day weather forecast for a specific location and given options.
  Checks wether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_five_day_forecast(map, key: atom) :: map
  def get_five_day_forecast(location, opts) do
    case Cache.FiveDayForecast.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_five_day_forecast, location, opts)
        Cache.FiveDayForecast.set(location, result, ttl: :infinity)

      # If location was cached, return it
      location ->
        location
    end
  end

  @doc """
  Returns sixteen day weather forecast for a specific location and given options.
  Checks wether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_sixteen_day_forecast(map, key: atom) :: map
  def get_sixteen_day_forecast(location, opts) do
    case Cache.SixteenDayForecast.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_sixteen_day_forecast, location, opts)
        Cache.SixteenDayForecast.set(location, result, ttl: :infinity)

      # If location was cached, return it
      location ->
        location
    end
  end
end
