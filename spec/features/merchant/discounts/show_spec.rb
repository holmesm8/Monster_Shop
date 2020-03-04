require 'rails_helper'

RSpec.describe 'merchant dashboard', type: :feature do
  describe 'As a merchant user' do
    before :each do
      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @user = User.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy33@hotmail.com", password: "sfgdfg", role: 0)
      @user_2 = @bike_shop.users.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy123@hotmail.com", password: "test", role: 1)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @discount_1 = @bike_shop.discounts.create!(name: "1% Discount", percent_off: 1, min_quantity: 10)
      @discount_2 = @bike_shop.discounts.create!(name: "5% Discount", percent_off: 5, min_quantity: 20)
      @tire_discount = ItemDiscount.create!(item_id: @tire.id, discount_id: @discount_1.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_2)
      visit '/merchant/discounts'
    end

    it "can go to a bulk discounts show page" do
      within("#discount#{@discount_1.id}") do
        click_link("#{@discount_1.name}")
      end

      expect(current_path).to eq(merchant_discount_path(@discount_1.id))
      expect(page).to have_content(@discount_1.name)
      expect(page).to have_content(@discount_1.percent_off)
      expect(page).to have_content(@discount_1.min_quantity)
      expect(page).to have_content(@tire.name)

      expect(page).to_not have_content(@discount_2.name)
    end
  end
end
