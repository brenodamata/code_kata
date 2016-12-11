require 'cart'

RSpec.describe Cart do
  example do
    expect(described_class).to equal(Cart)
  end

  before do
    @item = Item.new("Apple", 0.50)
    @cart = Cart.new
  end

  context 'Default values' do
    it 'defaults total to $0.0' do
      expect(@cart.total).to eq("$0.0")
    end

    it 'defaults to empty cart' do
      expect(@cart.items).to be_empty
    end
  end

  context '#add_item' do
    it 'only adds Item objects' do
      expect{@cart.add_item(@item,1)}.to change{@cart.items.size}.from(0).to(1)
    end

    it 'doesn\'t add any other types of objects' do
      @cart.add_item(@cart,1)
      expect(@cart.items).to be_empty
    end

    it 'adds multiple quantity' do
      expect{@cart.add_item(@item,5)}.to change{@cart.total_quantity}.from(0).to(5)
    end
  end

  context '#weight_add_item' do
    before do
      @steak = Item.new('Steak', 9.50, true)
    end

    it 'accepts pounds as unit of measure' do
      expect{@cart.weight_add_item(@steak, 2, 'pounds')}.
        to change{@cart.total_quantity}.from(0).to(2)
    end

    it 'accepts lbs as unit of measure' do
      expect{@cart.weight_add_item(@steak, 2, 'lbs')}.
        to change{@cart.total_quantity}.from(0).to(2)
    end

    it 'accepts lb as unit of measure' do
      expect{@cart.weight_add_item(@steak, 1, 'lb')}.
        to change{@cart.total_quantity}.from(0).to(1)
    end

    it 'accepts pound as unit of measure' do
      expect{@cart.weight_add_item(@steak, 1, 'pound')}.
        to change{@cart.total_quantity}.from(0).to(1)
    end

    it 'accepts pzs as unit of measure' do
      expect{@cart.weight_add_item(@steak, 16, 'ozs')}.
        to change{@cart.total_quantity}.from(0).to(1)
    end

    it 'accepts ounces as unit of measure' do
      expect{@cart.weight_add_item(@steak, 16, 'ounces')}.
        to change{@cart.total_quantity}.from(0).to(1)
    end

    it 'accepts oz as unit of measure' do
      expect{@cart.weight_add_item(@steak, 1, 'oz')}.
        to change{@cart.total_quantity}.from(0).to(1/16.0)
    end

    it 'accepts ounce as unit of measure' do
      expect{@cart.weight_add_item(@steak, 1, 'ounce')}.
        to change{@cart.total_quantity}.from(0).to(1/16.0)
    end

    it 'converts ounces to lbs' do
      @cart.weight_add_item @steak, 24, 'ounces'
      expect(@cart.total_quantity).to eq(24/16.0)
    end
  end

  context '#get_price' do

  end

  context '#update_total' do

  end

  context '#print_items' do

  end

  context '#receipt' do

  end

  context '#list_items' do

  end
end
