require 'item'

RSpec.describe Item do
  example do
    expect(described_class).to equal(Item)
  end

  context 'Default values' do
    before do
      @item = Item.new("Apple")
    end

    it 'is not valid without a name' do
      expect { Item.new }.to raise_error ArgumentError
    end

    it 'defaults price to 0.0' do
      expect(@item.price).to eq(0.0)
    end

    it 'defaults weight to false' do
      expect(@item.weight).to be_falsy
    end

    it 'has a bar code' do
      expect(@item.bar_code).not_to be_empty
    end
  end

  context 'Simple Item' do
    before do
      @item = Item.new("Apple", 0.50)
    end

    it 'costs 50 cents' do
      expect(@item.price).to eq(0.50)
    end
  end

  context '#set_promotion' do
    before do
      @item = Item.new("Apple", 1)
      @item.set_promotion 4,3
    end

    it 'is 4 for the price of 3' do
      expect(@item.promotion[:value]).to eq(@item.price * 3)
    end

    it 'requires a minimun amount for promotion' do
      expect(@item.min_quantity).to eq(@item.promotion[:min_quantity])
    end

    it 'has promotion' do
      expect(@item.promotion).to be_a(Hash)
    end
  end
end
