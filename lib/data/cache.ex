defmodule ExOwm.Data.Cache do
  use GenServer

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, :exowm_cache)
  end

  # Server implementation
  def init(_) do
    
  end
end
