defmodule ExOwm.Worker do
  use GenServer
  alias ExOwm.Api
  alias ExOwm.Coordinator

  ## Client API
  def start_link(params, opts \\ []) do
    GenServer.start_link(__MODULE__, params, opts)
  end

  def get_api_answer(pid) do
    GenServer.call(pid, {:get_answer})
  end

  ## Server implementation
  def init(params) do
    state = Api.call_owm_api(params)
    Coordinator.set_location_weather(state)
    {:ok, state}
  end

  def handle_call({:get_answer}, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
