defmodule ExOwm.Feature.Worker do
  alias ExOwm.Feature.Api
  
  def run(location) do
    Api.call_owm_api(location)
  end
end