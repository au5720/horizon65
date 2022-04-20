defmodule Product do
  @enforce_keys [:code, :name, :price]
  defstruct [:code, :name, :price]

  def load(data) do
    data |> Enum.map(&new/1)
  end

  def new(%{code: code, name: name, price: price}) do
    %Product{code: code, name: name, price: price}
  end

  def get(product_list, product_code) do
    case Enum.filter(product_list, fn product -> product.code == product_code end) do
      [product] -> product
      _ -> nil
    end
  end
end
