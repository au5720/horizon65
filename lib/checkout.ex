defmodule Checkout do
  @enforce_keys [:product_code]
  defstruct [:product_code]

  @moduledoc """

  """
  def calculate_total(products, basket, bonuses) do
    basket
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> calculate_line_items(products, bonuses)
  end

  defp calculate_line_items(items, products, bonuses) do
    Map.keys(items)
    |> Enum.map(fn
      code ->
        product = Product.get(products, code)
        qty = items[code]
        calculate_line_item(product, bonuses, qty)
    end)
    |> Enum.reduce(&(&1 + &2))
  end

  defp calculate_line_item(product, bonuses, qty) do
    Bonus.calculate(bonuses, product, qty)
  end

  def show(basket, total) do
    """
    Items: #{Enum.join(basket, ", ")}
    Total: #{Number.Currency.number_to_currency(total / 100, unit: "")}€
    """
  end

  def scan(basket, code) do
    basket ++ [code]
  end
end
