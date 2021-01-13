require_relative './item'
require_relative './openable'
require 'Time'

class ItemRepository
  include Openable

  attr_reader :items

  def initialize(file = './data/items.csv', engine)
    @engine = engine
    @file = file
    @items = []
    item_objects(read_from(@file))
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

  def item_objects(items)
    items.each do |item|
      precision      = item[:unit_price].length
      value_adjusted = item[:unit_price].to_i * 0.01
      @items << Item.new({:id => item[:id].to_i,
                :name        => item[:name],
                :description => item[:description],
                :unit_price  => BigDecimal.new(value_adjusted, precision),
                :created_at  => Time.parse(item[:created_at]),
                :updated_at  => Time.parse(item[:updated_at]),
                :merchant_id => item[:merchant_id].to_i})
    end
    @items
  end

  def all
    @items
  end

  def find_by_id(id)
    @items.select do |item|
          item.id == id
    end[0]
  end

  def find_by_merchant_id(merchant_id)
    @items.select do |item|
      item.merchant_id == merchant_id
    end
  end

  def find_by_name(name)
    item_name = []
    @items.each do |row|
      item_name << row if row.name == name
    end
    item_name[0]
  end

  def find_all_with_description(description)
    @items.find_all do |row|
      row.description.downcase == description.downcase
    end
  end

  def find_all_by_price(price)
    @items.find_all do |row|
      row.unit_price_to_dollars == price
    end
  end

  def find_all_by_price_in_range(range)
    @items.find_all do |row|
      range.include?(row.unit_price_to_dollars)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @items.find_all do |row|
      row.merchant_id == merchant_id
    end
  end

  def create(attributes)
    new_item = Item.new({id: (sort_by_id[-1].id + 1),
                        name: attributes[:name],
                 description: attributes[:description],
                  unit_price: attributes[:unit_price],
                  created_at: attributes[:created_at],
                  updated_at: attributes[:updated_at],
                 merchant_id: attributes[:merchant_id]})
    @items << new_item
    new_item
  end

  def sort_by_id
    @items.sort_by do |row|
      row.id
    end
  end

  def update(id, attributes)
    item = find_by_id(id)
    if item != nil
      attributes.each do |attribute_key, attribute_value|
        item.update({attribute_key => attribute_value})
      end
    end
    item
  end

  def delete(id)
    @items.delete(find_by_id(id))
  end
end
