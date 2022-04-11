defmodule Bonus do

  @doc """
  Bonus 
    :two_for_one - Buy One get one free - for Orders over 1 - only applies once.
    :three_or_more - Get a 5% discount on order greater than or equal to 3 

  ## Examples

    iex> Bonus.apply(:two_for_one, 2, 570)
    570

    iex> Bonus.apply(:two_for_one, 10, 500)
    4500

    iex> Bonus.apply(:three_or_more, 2, 570)
    1140

    iex> Bonus.apply(:three_or_more, 10, 500)
    4750
  """
  def apply(:two_for_one, product_qty, price) when product_qty > 1 do
    (product_qty - 1) * price
  end

  def apply(:three_or_more, product_qty, price) when product_qty > 2 do
      discountedPrice = price * 0.95
      round(product_qty * discountedPrice)
  end

  def apply(_default, product_qty, price ) do
    product_qty * price
  end

end