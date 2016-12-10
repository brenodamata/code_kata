class Item
  attr_accessor :name, :weight, :price
  def initialize(name, weight=false, price=0.0)
    @name = name
    @weight = weight
    @price = price
    @promotion = Hash.new
  end

  def promotion
    @promotion
  end

  # eg.: 4 for 3 => min_quantity = 4, discaount = 25
  # item.price = 10, 4i = (10*4)*0.75
  def set_promotion min_quantity, discount
    @promotion[:min_quantity] = min_quantity
    @promotion[:discount] = discount
    @promotion[:value] = (min_quantity * @price) * ((discount-100).abs * 0.01)
  end

  def min_quantity
    @promotion.empty? ? nil : @promotion[:min_quantity]
  end

end

class Cart
  # attr_accessor :total
  def initialize
    @items = []
    @total = 0.0
  end
  def items
    @items
  end
  def total
    "$#{@total.round(2)}"
  end
  def add_item item, quantity=1
    if item.class == Item
      quantity.times do
        @items << item
      end
    end
    update_total
  end
  def update_total
    @items.sort!{ |a,b| a.name <=> b.name }
    grouped_hash = @items.group_by(&:name)
    @total = 0.0

    grouped_hash.each do |name, obj|
      quantity = obj.size
      item = obj.first
      if quantity > 1 && !item.min_quantity.nil?
        promotions = quantity / item.min_quantity
        off_promo = quantity % item.min_quantity
        @total += (promotions * item.promotion[:value]) + (off_promo * item.price)
      else
        @total += item.price * quantity
      end
    end
  end
end

#  Test
banana = Item.new("banana")
banana.price = 1

fflakes = Item.new("Frosted Flakes")
fflakes.price = 10
fflakes.set_promotion 4,25

cart = Cart.new
cart.add_item banana, 2
cart.add_item fflakes, 3
puts "So far: #{cart.total}"


cart.add_item fflakes, 3
cart.add_item banana, 2
puts "So far: #{cart.total}"
