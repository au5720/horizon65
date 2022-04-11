defmodule TestData do
  @enforce_keys [:basket, :total] 
  defstruct [:basket, :total] 

  def load_test_data() do
    test_data()
    |> Enum.map(&new_testdata/1)
  end

  def new_testdata(%{basket: basket, total: total}) do
    %TestData{basket: basket, total: total}
  end

  def test_data() do
    [
      %{
        basket: ["VOUCHER","TSHIRT", "VOUCHER"],
        total: 2500
      },
      %{
        basket: ["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"],
        total: 8100
      },
      %{
        basket: ["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG", "TSHIRT", "TSHIRT"],
        total: 7450
      },
    ]

  end

end