defmodule ExOwm.Feature.Supervisor do
  use Supervisor
  alias ExOwm.Feature.Coordinator

  ## Client API
  def start_link(options \\ []) do
    Supervisor.start_link(__MODULE__, [], options ++ [name: __MODULE__])
  end

  ## Server implementation
  def init(_) do
    children = [
      worker(Coordinator, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
