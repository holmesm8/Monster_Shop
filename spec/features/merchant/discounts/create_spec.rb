require 'rails_helper'

RSpec.describe 'merchant dashboard', type: :feature do
  describe 'As a merchant user' do
    before :each do
      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @user = User.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy33@hotmail.com", password: "sfgdfg", role: 0)
      @user_2 = @bike_shop.users.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy123@hotmail.com", password: "test", role: 1)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @discount_1 = @bike_shop.discounts.create!(name: "1% Discount", percent_off: 1, min_quantity: 10)
      @discount_2 = @bike_shop.discounts.create!(name: "5% Discount", percent_off: 5, min_quantity: 20)
      @discount_3 = @meg.discounts.create!(name: "10% Discount", percent_off: 10, min_quantity: 30)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_2)
      visit '/merchant'
      click_link "Manage Bulk Discounts"
    end

    it "can link to create a new discount associated with an item" do
      visit '/merchant'
      click_link "Manage Bulk Discount"

      click_link "New Bulk Discount"
      expect(current_path).to eq("/merchant/discounts/new")

      within "#item-#{@tire.id}" do
        page.check "item_"
      end

      fill_in "Name", with: "20% Discount"
      fill_in "Percent off", with: 20
      fill_in "Min quantity", with: 50
      click_on "Create Discount"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("20% Discount")

      created_discount_item = ItemDiscount.last
      expect(created_discount_item.discount.name).to eq("20% Discount")
    end
  end
end
