defmodule ExOwm.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children =
      if cache_enabled?() do
        [ExOwm.Cache]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: ExOwm.Supervisor)
  end

  defp cache_enabled? do
    Application.get_env(:ex_owm, :cache_enabled, true)
  end
end
