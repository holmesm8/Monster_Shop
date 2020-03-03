require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @user = User.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy33@hotmail.com", password: "sfgdfg", role: 0)
      @user_2 = @bike_shop.users.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy123@hotmail.com", password: "test", role: 1)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
      @seat = @meg.items.create(name: "Seat", description: "So Comfy", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
      @discount_1 = @bike_shop.discounts.create!(name: "10% Discount", percent_off: 10, min_quantity: 3)
      @discount_2 = @bike_shop.discounts.create!(name: "5% Discount", percent_off: 5, min_quantity: 5)
      @tire_discount = ItemDiscount.create!(item_id: @tire.id, discount_id: @discount_1.id)
      @chain_discount = ItemDiscount.create!(item_id: @chain.id, discount_id: @discount_2.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "can add an item with a discount to the cart and have the discounted price showing" do
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"

      visit "/cart"
      within "#cart-quantity-#{@tire.id}" do
        find('#increment').click
        find('#increment').click
      end

      within "#cart-quantity-#{@tire.id}" do
        expect(page).to have_content("$27.00")
      end
    end
  end
end
