defmodule TransientSupervisor.Worker do
  require Logger
  use GenServer

  #######
  # API #
  #######

  def start_link([seconds_to_end], opts),
    do: GenServer.start_link(__MODULE__, [seconds_to_end], opts)

  ##############
  # Callbackes #
  ##############

  def init([seconds_to_sleep]) do
    Process.send_after(self(), {:do_task, seconds_to_sleep}, 1_000)
    {:ok, []}
  end

  def handle_info({:do_task, secs_to_sleep}, state) do
    Logger.debug("#{inspect(self())} task will end in #{inspect(secs_to_sleep)} seconds")
    :timer.sleep(secs_to_sleep * 1000)
    {:stop, :normal, state}
  end

  def terminate(_reason, state) do
    Logger.debug("#{inspect(self())} task is exiting")
    Task.start(TransientSupervisor.TransientSupervisor, :stop_transient_supervisor, [])
    {:ok, state}
  end
end
