require 'rails_helper'

describe ItemDiscount, type: :model do
  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :discount}
  end
end
