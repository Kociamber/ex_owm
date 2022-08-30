defmodule ExOwm.WorkerHelper do
  @moduledoc false
  alias ExOwm.Cache

  @spec get_from_cache_or_call(String.t(), 	fun(), pos_integer()) :: {:ok, map()} | {:error, map()} | {:error, map(), map()}
  def get_from_cache_or_call(cache_key, api_fun , ttl \\ :timer.minutes(10)) do
    case Cache.get(cache_key) do
      # If location wasn't cached within last ttl minutes, call OWM API
      nil ->
        result = api_fun.()
        Cache.put(cache_key, result, ttl: ttl)
        result

      # If location was cached, return it
      location ->
        location
    end
  end

end
