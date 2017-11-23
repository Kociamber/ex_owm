defmodule ExOwm do
  require Logger
  use Application
  @moduledoc """
  Documentation for ExOwm, OpenWeatherMap API Elixir library.
  """

  def start(_type, _args) do
    import Supervisor.Spec
    Logger.info "Starting supervision tree for #{inspect(__MODULE__)}"

    children = [
      supervisor(ExOwm.Feature.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @doc """
  Gets temperature of the given location by openweathermap id.

  ## Examples

      iex> ExOwm.get_weather_by_id([1,2,3,4,5])
      %{}

  """
  def get_weather_by_id(locations) when is_list(locations) do
    ExOwm.Feature.Coordinator.start_workers(locations)
    ExOwm.Feature.Coordinator.get_state()
  end

end
