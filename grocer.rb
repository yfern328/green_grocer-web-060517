def consolidate_cart(cart)

  consolidated_cart = {}
  counter = Hash.new(0)

  cart.each do |el|
    el.each do |item, hash|
      counter[item] += 1
    end
  end

  cart.each do |el|
    el.each do |item, hash|
      consolidated_cart[item] = hash
      consolidated_cart[item][:count] = counter[item]
    end
  end

  consolidated_cart

end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.include?(coupon[:item]) && coupon[:num] <= cart[coupon[:item]][:count]
      if cart.include?("#{coupon[:item]} W/COUPON")
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
        cart[coupon[:item]][:count] -= coupon[:num]
      else
        cart["#{coupon[:item]} W/COUPON"] = {}
        cart["#{coupon[:item]} W/COUPON"][:price] = coupon[:cost]
        cart["#{coupon[:item]} W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
        cart["#{coupon[:item]} W/COUPON"][:count] = 1
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each {|item, data| cart[item][:price] = (cart[item][:price] * 0.8).round(2) if cart[item][:clearance]}
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)

  total = 0
  new_cart.each {|item, data| total += new_cart[item][:price] * new_cart[item][:count]}
  total > 100 ? total = (total * 0.9).round(2) : total
end
