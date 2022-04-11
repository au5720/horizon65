
enum discountType {
  TWO_FOR_ONE = 'Two-For-One',
  THREE_OR_MORE = 'Three-Or-More'
}

interface Basket {
  productCodes : string[]
}

interface Order {
  items : OrderItem[],
  total : number
}

interface OrderItem {
  product : Product,
  quantity: number
}

interface Product {
  code: string,
  name: string,
  price: number,
  bonus?: discountType
}

interface discountRule {
  discountName: discountType, discountFn : discountFN
}

interface discountFN {
  (quantity : number, price : number) : number
}

const loadProducts = () : Product[] => {
  return [
    {
      code   : 'VOUCHER',
      name   : 'Voucher',
      price  : 500,
      bonus  : discountType.TWO_FOR_ONE 
    },
    {
      code  : 'TSHIRT',
      name  : 'T-Shirt',
      price : 2000,
      bonus : discountType.THREE_OR_MORE
    },
    { code: 'MUG', name: 'Coffee Mug', price: 750  },
  ]
}

const products : Product[] = loadProducts()

/*
  DISCOUNT FUNCTIONS
*/

const discountNone  = (product_quantity : number, price : number) : number => {
  return product_quantity * price
}

/*
    DISCOUNT_TWO_FOR_ONE
      if we have more than one product give one free gratis
      you buy two products and only pay for one
*/

const discountFnTwoForOne = (product_quantity : number, price : number) : number => {
  if (product_quantity > 1) {
    return (product_quantity - 1) * price
  }
  return product_quantity * price
}

/*
    DISCOUNT_THREE_OR_MORE
      if we have three or more of a product we give a discount on the price
*/

const discountFnThreeOrMore = (product_quantity : number, price : number) : number => {
  if (product_quantity > 2) {
    const discountedPrice = price * 0.95
    return product_quantity * discountedPrice
  }
  return product_quantity * price
}

//
//TODO - this will need to fetch from Database
//
const loadDiscountRules = () => { 
  return [
      { discountName: discountType.TWO_FOR_ONE, discountFn: discountFnTwoForOne },
      { discountName: discountType.THREE_OR_MORE, discountFn: discountFnThreeOrMore },
  ]
}

const discountRules : discountRule[] = loadDiscountRules()



//
//TODO - this will need to fetch from Database
//
const fetchProduct = (productCode : String) : Product => {
  
  return products.filter(
    (p) => p.code == productCode
  )[0]
}

//
//TODO - populated on startup from bonus table in database 
// Bonus Library
// 
const fetchDiscountRule = (discount : discountType) : discountFN => {
  let rule : discountRule = discountRules.filter((e) => e.discountName == discount)[0]
  if(rule) {
    return rule.discountFn
  } else {
    return discountNone
  }
}

const groupShoppingBasket = (currentBasket : Basket) : Order  => {
  let orderItems : OrderItem[] = []
  currentBasket.productCodes.forEach(code => {
    let product = fetchProduct(code)
    if(product){
      let order = orderItems.filter( (item: OrderItem) : OrderItem => item.product.code === product.code ? item : null  )[0]
      if(order){
        order.quantity += 1
      } else {
        orderItems.push( { product, quantity: 1 })
      }
    } else {
      return {items: [], total: 0}
    }
  })
  return { items : orderItems, total : 0}
}

const calcOrderTotal = (order: Order) : Order => {
  let orderItems = order.items
  orderItems.forEach(item => {
    order.total += fetchDiscountRule(item.product.bonus)(item.quantity, item.product.price)
  })
  return order
}
/**
 * 
 * @param basket 
 * @returns 
 */

const calculateTotal = (basket : Basket) : number => {

  let order = groupShoppingBasket(basket)
  order = calcOrderTotal(order)
  // Do something else with the order
  return order.total

}




/**
 * TESTS
 */
interface Test {
  basket: string[],
  total: number 
}



const test = (testData : Test[]) : void => {
  testData.forEach(element => {
    const basketList = element.basket
    const total = calculateTotal({ productCodes: basketList})
    if(total === element.total){
      console.log('Passed')
    } else {
      console.log('Failed', element.basket)
    }
  });
}

test(testData)


