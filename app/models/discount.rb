class Discount <ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name,
                        :percent_off,
                        :min_quantity

  has_many :item_discounts, dependent: :destroy
  has_many :items, through: :item_discounts
end
