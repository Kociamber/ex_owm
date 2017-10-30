defmodule ExOwm.Feature.Worker do
  use GenServer
  alias ExOwm.Feature.Api
  alias ExOwm.Feature.Coordinator

  ## Client API
  def start_link(params) do
    name =
      params
      |> List.first()
      |> Map.get(:id)
      |> Integer.to_string()
      |> Kernel.<>("_worker")
      |> String.to_atom()
  
      IO.inspect name
      GenServer.start_link(__MODULE__, params, name: name)
  end

  def get_state(pid) do
    GenServer.call(pid, {:get_state})
  end

  ## Server implementation
  def init(params) do
    state = Api.call_owm_api(params)
    Coordinator.set_location_weather(state)
    {:ok, state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
