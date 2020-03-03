class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    if best_discount(item)
      discounted_subtotal(item)
    else
      item.price * @contents[item.id.to_s]
    end   
  end

  def total
    @contents.sum do |item_id,quantity|
      item = Item.find(item_id)
      if best_discount(item)
        discounted_subtotal(item)
      else
        item.price * quantity
      end
    end
  end

  def discounted_subtotal(item)
    subtotal = (item.price * @contents[item.id.to_s])
    subtotal - (subtotal * best_discount(item))
  end

  def best_discount(item)
    highest_discounts = item.discounts.order(min_quantity: :desc)
    highest = 0
    highest_discounts.each do |discount|
      if @contents[item.id.to_s] >= discount.min_quantity
        highest = discount.percent_off
        break
      end
    end
    highest / 100.to_f
  end

  def add_quantity id
    @contents[id] += 1
  end

  def subtract_quantity id
    @contents[id] -= 1
  end

  def limit_reached? id
    @contents[id] == Item.find(id.to_s).inventory
  end

  def quantity_zero?(id)
    @contents[id] == 0
  end
end
