defmodule ExOwm.CurentWeather.Coordinator do
  @moduledoc """
  This module is a GenServer implementation created for handling concurrent
  worker task coordination.
  """
  use GenServer
  alias ExOwm.CurentWeather.Worker

  ## Client API
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options ++ [name: :current_weather_coordinator])
  end

  def get_weather(locations, opts) do
    GenServer.call(:current_weather_coordinator, {:get_current_weather, locations, opts})
  end

  ## Server implementation
  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_current_weather, locations, opts}, _from, _state) do
    spawn_worker_tasks(locations, opts)
  end

  defp spawn_worker_tasks(locations, opts) do
    worker_tasks =
      Enum.map(locations, fn location ->
        Task.async(Worker, :get_current_weather, [location, opts])
      end)

    results = Enum.map(worker_tasks, fn task -> Task.await(task) end)
    {:reply, results, results}
  end
end
