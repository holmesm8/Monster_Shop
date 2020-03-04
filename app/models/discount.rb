class Discount <ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :percent_off, less_than_or_equal_to: 100
  validates_presence_of :min_quantity

  has_many :item_discounts, dependent: :destroy
  has_many :items, through: :item_discounts
end
