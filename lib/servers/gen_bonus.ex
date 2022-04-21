defmodule Bonus.Server do
  use GenServer
  @name __MODULE__

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  # CLIENT API
  def load(data) do
    GenServer.call(@name, {:load, data})
  end

  def get(code) do
    GenServer.call(@name, {:get, code})
  end

  # GENSERVER MESSAGES
  def init(_opts) do
    {:ok, []}
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
end
