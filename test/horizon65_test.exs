defmodule Horizon65Test do
  use ExUnit.Case

  setup_all do
    {:ok, test_data: test_data()}
  end

  test "Calculate total", state do
    [products, bonus_table] = state[:test_data]

    # Test 1
    basket =
      []
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("VOUCHER")

    assert Checkout.calculate_total(products, basket, bonus_table) == 2500

    # Test 2
    basket =
      []
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("TSHIRT")

    assert Checkout.calculate_total(products, basket, bonus_table) == 8100

    # Test 3
    basket =
      []
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("MUG")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("TSHIRT")

    assert Checkout.calculate_total(products, basket, bonus_table) == 7450
  end

  test "Product Tests", state do
    [products, _bonus_table] = state[:test_data]

    # Validate our test Data is loaded
    assert length(products) == 3

    # Check we can retrieve a product
    aProduct = products |> Product.get("VOUCHER")
    assert aProduct.code == "VOUCHER"
  end

  test "Bonus Calculations" do
    assert Bonus.apply_bonus(:two_for_one, 2, 570) == 570

    assert Bonus.apply_bonus(:two_for_one, 10, 500) == 4500

    assert Bonus.apply_bonus(:three_or_more, 2, 570) == 1140

    assert Bonus.apply_bonus(:three_or_more, 10, 500) == 4750
  end

  test "Show Checkout Details", state do
    [products, bonus_table] = state[:test_data]

    ans = """
    Items: VOUCHER, TSHIRT, MUG
    Total: 32.50€
    """

    basket =
      []
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("MUG")

    total = Checkout.calculate_total(products, basket, bonus_table)
    result = Checkout.show(basket, total)
    assert ans === result
  end

  def test_data() do
    product_data = [
      %{code: "VOUCHER", name: "Voucher", price: 500},
      %{code: "TSHIRT", name: "T-Shirt", price: 2000},
      %{code: "MUG", name: "Coffee Mug", price: 750}
    ]

    bonus_data = [
      %{code: "VOUCHER", bonus: :two_for_one},
      %{code: "TSHIRT", bonus: :three_or_more}
    ]

    products = Product.load(product_data)
    bonus_table = Bonus.load(bonus_data)
    [products, bonus_table]
  end
end
