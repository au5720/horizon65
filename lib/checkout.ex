defmodule Checkout do
  @enforce_keys [:product_code]
  defstruct [:product_code]

  @moduledoc """

  """
  def calculate_total(basket) do
    basket
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> calculate_line_items()
  end

  defp calculate_line_items(items) do
    Map.keys(items)
    |> Enum.map(fn
      code ->
        product = Product.get(code)
        qty = items[code]
        calculate_line_item(product, qty)
    end)
    |> Enum.reduce(&(&1 + &2))
  end

  defp calculate_line_item(product, qty) do
    Bonus.calculate(product, qty)
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
