defmodule Product.Server do
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

  def all() do
    GenServer.call(@name, {:all})
  end

  def stop() do
    GenServer.call(@name, :stop)
  end

  def init(_) do
    # trap all exits!
    Process.flag(:trap_exit, true)
    {:ok, %{}, {:continue, :setup_queue}}
  end

  def handle_continue(:setup_queue, state) do
    # do heavy lifting
    {:noreply, state}
  end

  def handle_call({:get, code}, _from, state) do
    product =
      case Enum.filter(state, fn product -> product.code == code end) do
        [product] -> product
        _ -> nil
      end

    {:reply, product, state}
  end

  def handle_call({:all}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:load, data}, _from, _state) do
    state = data
    {:reply, :ok, state}
  end

  def handle_call(:stop, _from, status) do
    {:stop, :normal, status}
  end

  # def terminate(reason, _status) do
  #   IO.puts("Asked to stop because #{inspect(reason)}")
  #   :ok
  # end
end
