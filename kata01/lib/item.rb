require 'faker'

class Item
  attr_accessor :name, :weight, :price, :bar_code
  def initialize(name, price=0.0, weight=false)
    @name = name
    @weight = weight # pound
    @price = price
    @promotion = Hash.new
    @bar_code = Faker::Crypto.sha1 # no db to validate it's uniqueness
  end

  def promotion
    @promotion
  end

  # eg.: 4 for 3 => min_quantity = 4, discaount = 25
  # item.price = 10, 4i = (10*4)*0.75
  def set_promotion_old min_quantity, discount
    @promotion[:min_quantity] = min_quantity
    @promotion[:discount] = discount
    @promotion[:value] = (min_quantity * @price) * ((discount-100).abs * 0.01)
  end

  def set_promotion get, pay
    @promotion[:min_quantity] = get
    @promotion[:value] = pay * @price
  end

  def min_quantity
    @promotion.empty? ? nil : @promotion[:min_quantity]
  end

end
