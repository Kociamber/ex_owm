defmodule ExOwm.Feature.Worker do
  alias ExOwm.Feature.ApiCaller
  
  def run(location, opts) do
    ApiCaller.send_and_parse_request(location, opts)
  end
end