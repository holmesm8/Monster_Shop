require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'instance methods' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @cart = Cart.new({@chain.id.to_s => 1})
    end

    it '#add_quantity' do
      @cart.add_quantity(@chain.id.to_s)
      expect(@cart.contents[@chain.id.to_s]).to eq(2)
    end

    it 'subtract_quantity' do
      @cart.add_quantity(@chain.id.to_s)
      expect(@cart.contents[@chain.id.to_s]).to eq(2)
      @cart.subtract_quantity(@chain.id.to_s)
      expect(@cart.contents[@chain.id.to_s]).to eq(1)
    end

    it '#limit_reached?' do
      @cart = Cart.new({@chain.id.to_s => 5})
      expect(@cart.limit_reached?(@chain.id.to_s)).to eq(true)
      @cart.subtract_quantity(@chain.id.to_s)
      expect(@cart.limit_reached?(@chain.id.to_s)).to eq(false)
    end

    it '#quantity_zero?' do
      expect(@cart.quantity_zero?(@chain.id.to_s)).to eq(false)
      @cart.subtract_quantity(@chain.id.to_s)
      expect(@cart.quantity_zero?(@chain.id.to_s)).to eq(true)
    end

    it "#best_discount" do
      @discount = @bike_shop.discounts.create!(name: "10% Discount", percent_off: 10, min_quantity: 5)
      @discount2 = @bike_shop.discounts.create!(name: "15% Discount", percent_off: 15, min_quantity: 6)
      @item_discount = ItemDiscount.create!(item_id: @chain.id, discount_id: @discount.id)
      @item_discount2 = ItemDiscount.create!(item_id: @chain.id, discount_id: @discount2.id)
      cart = Cart.new(@chain.id.to_s => 10)
      expected_result = 0.15

      expect(cart.best_discount(@chain)).to eq(expected_result)
    end


    it "#discounted_subtotal" do
      @discount = @bike_shop.discounts.create!(name: "10% Discount", percent_off: 10, min_quantity: 5)
      @item_discount = ItemDiscount.create!(item_id: @chain.id, discount_id: @discount.id)

      cart = Cart.new(@chain.id.to_s => 5)
      expect(cart.discounted_subtotal(@chain)).to eq(225)
    end
  end
end
