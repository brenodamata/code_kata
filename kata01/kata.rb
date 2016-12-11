require "#{Dir.pwd}/lib/cart.rb"
require "#{Dir.pwd}/lib/item.rb"

##########  Create new items ##########
banana = Item.new("Banana Maça", 0.66)
banana.set_promotion 3,2

fflakes = Item.new("Frosted Flakes", 10)
fflakes.set_promotion 4,3

meat = Item.new("Rib Eye Steak", 12, true)
meat.set_promotion 5, 4
##########  Create new items ##########

cart = Cart.new
cart.add_item banana, 3
cart.add_item fflakes, 3
# puts "So far: #{cart.total} => #{cart.print_items}"


cart.add_item fflakes, 2
cart.add_item banana, 4
# puts "So far: #{cart.total} => #{cart.print_items}"
cart.weight_add_item meat, 5, 'lbs'
# puts "So far: #{cart.total} => #{cart.print_items}"
cart.receipt
