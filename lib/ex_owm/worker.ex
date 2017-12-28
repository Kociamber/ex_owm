defmodule ExOwm.Worker do
  alias ExOwm.Api
  alias ExOwm.Cache

  def get_current_weather(location, opts) do
    case Cache.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_current_weather, location, opts)
        Cache.set(location, result, ttl: 10)
      # If location was cached within last 10 minutes, return it
      location ->
        location
    end
  end

  def get_five_day_forecast(location, opts) do
    case Cache.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_five_day_forecast, location, opts)
        Cache.set(location, result, ttl: 30)
      # If location was cached within last 10 minutes, return it
      location ->
        location
    end
  end

  def get_sixteen_day_forecast(location, opts) do
    case Cache.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_sixteen_day_forecast, location, opts)
        Cache.set(location, result, ttl: 1000)
      # If location was cached within last 10 minutes, return it
      location ->
        location
    end
  end
end
