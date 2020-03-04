class Discount <ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  # validates_presence_of :percent_off, less_than_or_equal_to: 100
  # validates_presence_of :min_quantity, more_than: 0

  validates :percent_off, presence: true, numericality: { greater_than: 0, less_than: 100 }
  validates :min_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :item_discounts, dependent: :destroy
  has_many :items, through: :item_discounts
end
