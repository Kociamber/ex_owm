defmodule ExOwm.Feature.Worker do
  alias ExOwm.Feature.ApiCaller

  # @todo:
  # 1. add timestamp interval
  # 2. Consider using generational cache, like: https://github.com/cabol/nebulex

  def run(location, opts) do
    # Check wether the request has been been already cached.
    case :ets.lookup(:exowm_cache, location) do
      [] ->
        # No location in cache - fetch API call result and cache it.
        result = ApiCaller.send_and_parse_request(location, opts)
        :ets.insert(:exowm_cache, {location ,result, DateTime.utc_now()})
        result
      [result] ->
        # Request already processed and chached - return it. 
        Kernel.elem(result, 1)
    end
  end
end
