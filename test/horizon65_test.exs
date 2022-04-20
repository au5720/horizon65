defmodule Horizon65Test do
  use ExUnit.Case, async: true

  setup do
    product_data = [
      %{code: "VOUCHER", name: "Voucher", price: 500},
      %{code: "TSHIRT", name: "T-Shirt", price: 2000},
      %{code: "MUG", name: "Coffee Mug", price: 750}
    ]

    {:ok, _product_pid} = start_supervised(Product.Server)
    Product.Server.load(product_data)

    bonus_data = [
      %{code: "VOUCHER", bonus: :two_for_one},
      %{code: "TSHIRT", bonus: :three_or_more}
    ]

    {:ok, _bonus_pid} = start_supervised(Bonus.Server)
    Bonus.Server.load(bonus_data)
    {:ok, []}
  end

  test "Calculate total" do
    # Test 1
    basket =
      []
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("VOUCHER")

    assert Checkout.calculate_total(basket) == 2500

    # Test 2
    basket =
      []
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("TSHIRT")

    assert Checkout.calculate_total(basket) == 8100

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

    assert Checkout.calculate_total(basket) == 7450
  end

  test "Product Tests" do
    products = Product.Server.all()
    # Validate our test Data is loaded
    assert length(products) == 3

    # Check we can retrieve a product
    aProduct = Product.get("VOUCHER")
    assert aProduct.code == "VOUCHER"
  end

  test "Bonus Calculations" do
    assert Bonus.apply_bonus(:two_for_one, 2, 570) == 570

    assert Bonus.apply_bonus(:two_for_one, 10, 500) == 4500

    assert Bonus.apply_bonus(:three_or_more, 2, 570) == 1140

    assert Bonus.apply_bonus(:three_or_more, 10, 500) == 4750
  end

  test "Show Checkout Details" do
    ans = """
    Items: VOUCHER, TSHIRT, MUG
    Total: 32.50€
    """

    basket =
      []
      |> Checkout.scan("VOUCHER")
      |> Checkout.scan("TSHIRT")
      |> Checkout.scan("MUG")

    total = Checkout.calculate_total(basket)
    result = Checkout.show(basket, total)
    assert ans === result
  end
end
