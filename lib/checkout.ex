defmodule Checkout do
  @moduledoc """

  """
  def calculate_total(products, basket) do
    basket
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> calc_line_items(products)
    # |> Enum.reduce(&(&1 + &2))
  end

  defp calc_line_items(items, products) do
    Map.keys(items) 
    |> Enum.map(fn 
      code ->
        product = Product.get_product(code, products)
        qty = items[code]
        calc_line_item(qty,product) 
      end)
    |> Enum.reduce(&(&1 + &2))

  end

  defp calc_line_item(qty, product) do
    Bonus.apply(product.bonus, qty, product.price)
  end

end


