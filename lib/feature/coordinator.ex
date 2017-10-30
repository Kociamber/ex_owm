defmodule ExOwm.Feature.Coordinator do
  use GenServer

## Client API
  def start_link([:calling_coordinator]) do
    GenServer.start_link(__MODULE__, :ok, name: :exowm_coordinator)
  end

  def get_state do
    GenServer.call(:exowm_coordinator, {:get_state})
  end

  def set_location_weather(location_weather) do
    GenServer.cast(:exowm_coordinator, {:set_location_weather, location_weather})
  end

  ## Server implementation
  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_location_weather, location_weather}, state) do
    {:noreply, [location_weather | state]}
  end

end
