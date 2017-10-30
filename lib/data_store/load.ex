defmodule ExOwm.Cache.Load do
  @file_path "data/city.list.json"

  def get_json do
    with {:ok, body} <- File.read(@file_path),
         {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end
end