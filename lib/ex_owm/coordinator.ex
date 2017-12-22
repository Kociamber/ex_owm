defmodule ExOwm.Coordinator do
  use GenServer
  alias ExOwm.Worker

  ## Client API
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options ++ [name: :exowm_coordinator])
  end

  def get_state do
    GenServer.call(:exowm_coordinator, {:get_state})
  end

  def start_workers(request_type, locations, opts) do
    GenServer.call(:exowm_coordinator, {:start_workers, request_type, locations, opts})
  end

  ## Server implementation
  def init(_) do
    :ets.new(:exowm_cache, [:named_table, :public, read_concurrency: true, write_concurrency: true])
    {:ok, %{}}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:start_workers, request_type, locations, opts}, _from, _state) do
    worker_tasks =
      case request_type do
        :get_current_weather ->
          Enum.map(locations, fn(location) -> Task.async(Worker, :get_current_weather, [location, opts]) end)
      end
    results = Enum.map(worker_tasks, fn(task) -> Task.await(task) end)
    {:reply, results, results}
  end
end