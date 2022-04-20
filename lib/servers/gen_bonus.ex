defmodule Bonus.Server do
  use GenServer
  @name __MODULE__

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  def load(data) do
    GenServer.call(@name, {:load, data})
  end

  def get(code) do
    GenServer.call(@name, {:get, code})
  end

  def stop() do
    GenServer.call(@name, :stop)
  end

  def init(_opts) do
    {:ok, 0}
  end

  def handle_call({:get, code}, _from, state) do
    bonus =
      case Enum.filter(state, fn bonus -> bonus.code == code end) do
        [%{bonus: bonus_atom}] -> bonus_atom
        _ -> nil
      end

    {:reply, bonus, state}
  end

  def handle_call({:load, data}, _from, _state) do
    state = data
    {:reply, :ok, state}
  end

  def handle_call(:stop, _from, status) do
    {:stop, :normal, status}
  end

  def terminate(reason, _status) do
    IO.puts("Asked to stop because #{inspect(reason)}")
    :ok
  end
end
