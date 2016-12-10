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
  def initialize
    @items = {}
    @total = 0.0
  end

  def items
    @items
  end

  def total
    update_total
    "$#{@total.round(2)}"
  end

  def weight_add_item item, weight, uom
    if item.weight
      if uom == ('lbs' || 'lbs' || 'pound' || 'pounds')
        quantity = weight
      elsif uom == ('oz' || 'ounce' || 'ozs' || 'ounces')
        quantity = weight / 16.0
      else
        raise "Unknown unit of measure"
      end
      add_item item, quantity
    else
      raise "Item '#{item.name}' is a single unit."
    end
  end

  def add_item item, quantity=1
    if item.class == Item
      if @items[item.bar_code]
        quantity += @items[item.bar_code][:quantity]
      else
        @items[item.bar_code] = {}
        @items[item.bar_code][:name] = item.name
      end

      @items[item.bar_code][:quantity] = quantity
      @items[item.bar_code][:total_price] = get_price item, quantity
    end
  end

  def get_price item, quantity
    if quantity > 1.0 && !item.min_quantity.nil?
      promotions = quantity / item.min_quantity
      off_promo = quantity % item.min_quantity
      (promotions * item.promotion[:value]) + (off_promo * item.price)
    else
      item.price * quantity
    end
  end

  def update_total
    @total = 0.0
    @items.each do |code, item|
      @total += item[:total_price]
    end
  end

  def print_items
    items = []
    @items.each do |code, item|
      items << "#{item[:quantity]}x #{item[:name]}"
    end
    items.join(', ')
  end
end

##########  Create new items ##########
banana = Item.new("banana", 1)

fflakes = Item.new("Frosted Flakes", 10)
fflakes.set_promotion 4,25

meat = Item.new("Rib Eye Steak", 10, true)
meat.set_promotion 2, 10
##########  Create new items ##########

cart = Cart.new
cart.add_item banana, 2
cart.add_item fflakes, 3
puts "So far: #{cart.total} => #{cart.print_items}"


cart.add_item fflakes, 2
cart.add_item banana, 2
puts "So far: #{cart.total} => #{cart.print_items}"
cart.add_item meat, 2
puts "So far: #{cart.total} => #{cart.print_items}"
