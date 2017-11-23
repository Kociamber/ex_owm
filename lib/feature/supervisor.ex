defmodule ExOwm.Feature.Supervisor do
  use Supervisor
  alias ExOwm.Feature.Coordinator
  # alias ExOwm.Feature.Worker

  ## Client API
  def start_link(options \\ []) do
    Supervisor.start_link(__MODULE__, [], options ++ [name: __MODULE__])
  end

  # def start_workers(params) do
  #   IO.puts "+++ start_workers"
  #   IO.inspect params
  #   Supervisor.start_link(Worker[params], strategy: :one_for_one)
  # end

  ## Server implementation
  def init(_) do
    children = [
      worker(Coordinator, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  # def start_worker(params) do
  #    Supervisor.start_child(ExOwm.Feature.Supervisor, {Worker, :start_link, params})
  # end
end