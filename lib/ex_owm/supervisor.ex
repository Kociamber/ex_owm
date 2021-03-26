defmodule ExOwm.Supervisor do
  @moduledoc """
  Standard Supervisor implementation. The only child is Coordinator GenSever
  used for concurrent OWM API calls handling.
  """
  use Supervisor

  ## Client API
  def start_link(options \\ []) do
    Supervisor.start_link(__MODULE__, [], options ++ [name: __MODULE__])
  end

  ## Server implementation
  def init(_) do
    children = [
      worker(ExOwm.CurrentWeather.Coordinator, []),
      worker(ExOwm.Weather.Coordinator, []),
      worker(ExOwm.FiveDayForecast.Coordinator, []),
      worker(ExOwm.SixteenDayForecast.Coordinator, []),
      worker(ExOwm.HistoricalWeather.Coordinator, []),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
