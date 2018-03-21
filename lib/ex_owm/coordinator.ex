defmodule ExOwm.Coordinator do
  @moduledoc """
  This module is GenServer implementation created for handling concurrent
  worker task coordination.
  """
  use GenServer
  alias ExOwm.Worker

  ## Client API
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options ++ [name: :exowm_coordinator])
  end

  def get_state do
    GenServer.call(:exowm_coordinator, {:get_state})
  end

  def start_workers(:get_current_weather, locations, opts) do
    GenServer.call(:exowm_coordinator, {:get_current_weather, locations, opts})
  end

  def start_workers(:get_five_day_forecast, locations, opts) do
    GenServer.call(:exowm_coordinator, {:get_five_day_forecast, locations, opts})
  end

  def start_workers(:get_sixteen_day_forecast, locations, opts) do
    GenServer.call(:exowm_coordinator, {:get_sixteen_day_forecast, locations, opts})
  end

  ## Server implementation
  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_current_weather, locations, opts}, _from, _state) do
    spawn_worker_tasks(:get_current_weather, locations, opts)
  end

  def handle_call({:get_five_day_forecast, locations, opts}, _from, _state) do
    spawn_worker_tasks(:get_five_day_forecast, locations, opts)
  end

  def handle_call({:get_sixteen_day_forecast, locations, opts}, _from, _state) do
    spawn_worker_tasks(:get_sixteen_day_forecast, locations, opts)
  end

  defp spawn_worker_tasks(api_call_type, locations, opts) do
    worker_tasks =
      case api_call_type do
        :get_current_weather ->
          Enum.map(locations, fn(location) -> Task.async(Worker, :get_current_weather, [location, opts]) end)
        :get_five_day_forecast ->
          Enum.map(locations, fn(location) -> Task.async(Worker, :get_five_day_forecast, [location, opts]) end)
        :get_sixteen_day_forecast ->
          Enum.map(locations, fn(location) -> Task.async(Worker, :get_sixteen_day_forecast, [location, opts]) end)
      end
    results = Enum.map(worker_tasks, fn(task) -> Task.await(task) end)
    {:reply, results, results}
  end
end
