require 'active_support/inflector'

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

  def total_quantity
    quantity = 0
    @items.each do |code, item|
      quantity += item[:quantity]
    end
    quantity
  end

  def weight_add_item item, weight, uom
    if item.weight
      if uom == 'lbs' || uom == 'lb' || uom == 'pound' || uom == 'pounds'
        quantity = weight
      elsif uom == 'oz' || uom == 'ounce' || uom == 'ozs' || uom == 'ounces'
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
        @items[item.bar_code][:item] = item
      end

      @items[item.bar_code][:quantity] = quantity
      @items[item.bar_code][:total_price] = get_price item, quantity
    end
  end

  def get_price_old item, quantity
    if quantity > 1.0 && !item.min_quantity.nil? && quantity >= item.min_quantity
      promotions = quantity / item.min_quantity
      off_promo = quantity % item.min_quantity
      (promotions * item.promotion[:value]) + (off_promo * item.price)
    else
      item.price * quantity
    end
  end

  def get_price item, quantity
    if !item.min_quantity.nil? && quantity >= item.min_quantity
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
    pitems = list_items
    pitems.join(', ')
  end

  def receipt
    @items.each do |code, item|
      if item[:item].weight
        puts "#{item[:quantity]} #{pluralize(item[:quantity], "pound")}\t#{item[:item].name}\t\t$#{item[:total_price].round(2)}"
      else
        puts "#{item[:quantity]}x\t\t#{item[:item].name}\t\t$#{item[:total_price].round(2)}"
      end
    end
    puts "Total: #{total}"
  end

  def list_items
    pitems = []
    @items.each do |code, item|
      if item[:item].weight
        pitems << "#{item[:quantity]} #{pluralize(item[:quantity], "pound")} #{item[:item].name}"
      else
        pitems << "#{item[:quantity]}x #{item[:item].name}"
      end
    end
    pitems
  end

  def pluralize(number, text)
    return text.pluralize if number != 1
    text
  end

end
