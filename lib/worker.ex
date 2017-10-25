defmodule WeatherEx.Worker do
  use GenServer

  ## Client API
  def start_link (opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  # Server implementation
  def init(:ok) do
    {:ok, %{}}
  end
end
