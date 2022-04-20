defmodule Product do
  @enforce_keys [:code, :name, :price]
  defstruct [:code, :name, :price]

  def load(data) do
    data |> Enum.map(&new/1)
  end

  def new(%{code: code, name: name, price: price}) do
    %Product{code: code, name: name, price: price}
  end

  def get(code) do
    Product.Server.get(code)
  end
end
