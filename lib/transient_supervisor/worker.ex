defmodule TransientSupervisor.Worker do
  require Logger
  use GenServer

  #######
  # API #
  #######

  def start_link([seconds_to_end], opts),
    do: GenServer.start_link(__MODULE__, [seconds_to_end], opts)

  def do_task(seconds_to_end),
    do: GenServer.cast(__MODULE__, {:do_task, seconds_to_end}, [])

  ##############
  # Callbackes #
  ##############

  def init([seconds_to_sleep]) do
    Process.send_after(self(), {:do_task, seconds_to_sleep}, 1_000)
    {:ok, []}
  end

  def handle_info({:do_task, seconds_to_sleep}, state) do
    Logger.info("#{inspect(self())} Starting task after #{inspect seconds_to_sleep} seconds")
    :timer.sleep(seconds_to_sleep * 1000)
    {:stop, :normal, state}
  end

  def terminate(_reason, state) do
    Logger.info("Exiting process #{inspect self()}")
    Task.start(TransientSupervisor.Supervisor, :stop_transient_supervisor, [])
    {:ok, state}
  end
end
