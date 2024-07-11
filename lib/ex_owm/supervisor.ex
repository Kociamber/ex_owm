defmodule ExOwm.Supervisor do
  @moduledoc """
  Standard Supervisor implementation. This supervisor oversees various Coordinator GenServers used for handling concurrent OpenWeatherMap API calls.
  """
  use Supervisor

  @spec start_link(keyword) :: Supervisor.on_start()
  def start_link(options \\ []) do
    Supervisor.start_link(__MODULE__, [], options ++ [name: __MODULE__])
  end

  @spec init(any) :: {:ok, tuple}
  def init(_) do
    children = [
      ExOwm.CurrentWeather.Coordinator,
      ExOwm.Weather.Coordinator,
      ExOwm.FiveDayForecast.Coordinator,
      ExOwm.HourlyForecast.Coordinator,
      ExOwm.SixteenDayForecast.Coordinator,
      ExOwm.HistoricalWeather.Coordinator
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
