defmodule Bonus do
  @enforce_keys [:code, :bonus]
  defstruct [:code, :bonus]

  def load(data) do
    data
    |> Enum.map(fn %{code: code, bonus: bonus} ->
      %Bonus{code: code, bonus: bonus}
    end)
  end

  @doc """
  Bonus
    :two_for_one - Buy One get one free - for Orders over 1 - only applies once.
    :three_or_more - Get a 5% discount on order greater than or equal to 3
  """

  def calculate(product, qty) do
    bonus = Bonus.Server.get(product.code)
    apply_bonus(bonus, qty, product.price)
  end

  def apply_bonus(:three_or_more, product_qty, price) when product_qty > 2 do
    discountedPrice = price * 0.95
    round(product_qty * discountedPrice)
  end

  def apply_bonus(:two_for_one, product_qty, price) when product_qty > 1 do
    # num_of_pairs = div(product_qty, 2)
    # remainder = rem(product_qty, 2)

    # (num_of_pairs + remainder) * price

    (product_qty - 1) * price
  end

  def apply_bonus(_default, product_qty, price) do
    product_qty * price
  end
end
