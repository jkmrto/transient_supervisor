defmodule TransientSupervisor.TransientSupervisor do
  require Logger
  @moduledoc false

  use Supervisor

  def start_link(),
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  def init(_arg) do
    children = [
      %{
        id: :worker_10,
        start: {TransientSupervisor.Worker, :start_link, [[10], [name: :worker_10]]},
        restart: :transient
      },
      %{
        id: :worker_15,
        start: {TransientSupervisor.Worker, :start_link, [[15], [name: :worker_15]]},
        restart: :transient
      }
    ]

    Supervisor.init(children, strategy: :one_for_one, restart: :transient)
  end

  def stop_transient_supervisor() do
    case Supervisor.count_children(__MODULE__) do
      %{active: 0} ->
        Logger.debug("Let's destroy  the supervisor")
        Supervisor.stop(__MODULE__, :normal)

      _ ->
        :ok
    end
  end
end
