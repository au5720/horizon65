defmodule Product do
  @enforce_keys [:code, :name, :price] 
  defstruct [:code, :name, :price, :bonus] 

  def load_products(data) do
    data |> Enum.map(&new_product/1)
  end

  def show_product(product) do
    out_str=" #{product.code} #{product.name} #{product.price} #{product.bonus} "
    IO.puts out_str
  end

  def new_product(%{code: code, name: name, price: price, bonus: bonus}) do
    %Product{code: code, name: name, price: price, bonus: bonus}
  end
  
  def new_product(%{code: code, name: name, price: price}) do
    %Product{code: code, name: name, price: price}
  end

  def add_product(products, %{code: code, name: name, price: price, bonus: bonus}) do
    new_product = %Product{code: code, name: name, price: price, bonus: bonus}
    products ++ [ new_product ]
  end

  def add_product(products, %{code: code, name: name, price: price}) do
    new_product = %Product{code: code, name: name, price: price}
    products ++ [ new_product ]
  end

  def get_product(product_code, product_list) do
    case Enum.filter(product_list , fn product -> product.code == product_code end) do
      [product] -> product 
       _ -> nil
    end
  end
end