defmodule ExOwm.HourlyForecast.Coordinator do
  @moduledoc """
  This module is a GenServer implementation created for handling concurrent
  worker task coordination.
  """
  use GenServer
  alias ExOwm.HourlyForecast.Worker

  ## Client API
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options ++ [name: :hourly_forecast_coordinator])
  end

  def get_weather(locations, opts) do
    GenServer.call(:hourly_forecast_coordinator, {:get_hourly_forecast, locations, opts})
  end

  ## Server implementation
  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_hourly_forecast, locations, opts}, _from, _state) do
    spawn_worker_tasks(locations, opts)
  end

  defp spawn_worker_tasks(locations, opts) do
    worker_tasks =
      Enum.map(locations, fn location ->
        Task.async(Worker, :get_hourly_forecast, [location, opts])
      end)

    results = Enum.map(worker_tasks, fn task -> Task.await(task) end)
    {:reply, results, results}
  end
end
