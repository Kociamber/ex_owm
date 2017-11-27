defmodule ExOwm.Feature.Coordinator do
  use GenServer
  alias ExOwm.Feature.Worker

  ## Client API
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options ++ [name: :exowm_coordinator])
  end

  def get_state do
    GenServer.call(:exowm_coordinator, {:get_state})
  end

  def start_workers(locations, opts) do
    GenServer.call(:exowm_coordinator, {:start_workers, locations, opts})
  end

  ## Server implementation
  def init(_) do
    :ets.new(:exowm_cache, [:named_table, :public, read_concurrency: true, write_concurrency: true])
    {:ok, %{}}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:start_workers, locations, opts}, _from, _state) do
    worker_tasks = Enum.map(locations, fn(location) -> Task.async(Worker, :run, [location, opts]) end)
    results = Enum.map(worker_tasks, fn(task) -> Task.await(task) end)
    {:reply, results, results}
  end
end
