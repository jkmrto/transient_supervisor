defmodule TransientSupervisor do
  use Application
  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      %{
        id: TransientSupervisor.Supervisor,
        start: {TransientSupervisor.Supervisor, :start_link, []},
        restart: :transient,
        type: :supervisor
      }
    ]

    opts = [strategy: :one_for_one, name: TransientSupervisor]
    Supervisor.start_link(children, opts)
  end

end
