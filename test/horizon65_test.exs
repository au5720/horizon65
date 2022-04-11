defmodule Horizon65Test do
  use ExUnit.Case
  doctest Horizon65
  doctest Bonus


  test "Calculate total" do
    testData = [%{code: "VOUCHER", name: "Voucher", price: 500, bonus: :two_for_one},
                %{code: "TSHIRT", name: "T-Shirt", price: 2000, bonus: :three_or_more},
                %{ code: "MUG", name: "Coffee Mug", price: 750} ]

    products = Product.load_products(testData)
    #Test 1
    basket=["VOUCHER","TSHIRT", "VOUCHER"]
    assert Checkout.calculate_total(products, basket) == 2500

    #Test 2
    basket=["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"]
    assert Checkout.calculate_total(products, basket) == 8100

    #Test 3
    basket=["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG", "TSHIRT", "TSHIRT"]
    assert Checkout.calculate_total(products, basket) == 7450
  end

  test "Product Tests" do
    testData = [%{code: "VOUCHER", name: "Voucher", price: 500, bonus: :two_for_one},
                %{code: "TSHIRT", name: "T-Shirt", price: 2000, bonus: :three_or_more},
                %{ code: "MUG", name: "Coffee Mug", price: 750} ]

    products = Product.load_products(testData)
    
    # Validate our test Data is loaded
    assert length(products) == 3

    # Check we can retrieve a product
    aProduct = Product.get_product("VOUCHER", products)
    assert aProduct.bonus == :two_for_one 

    # Check that we return nil if not found
    aProduct = Product.get_product("TV", products)
    assert aProduct == nil 

    # Check we can add a new Product
    a_new_product = Product.new_product(%{code: "TV", name: "Flatscreen TV", price: 1250 })
    new_products = Product.add_product(products, a_new_product)
    the_new_product = Product.get_product("TV", new_products)
    assert the_new_product.price == 1250

  end

end
