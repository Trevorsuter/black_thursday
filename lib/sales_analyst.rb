require_relative './sales_engine'
require_relative './item_repo'
require_relative './invoice_repo'
require_relative './merchant_repo'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def average_items_per_merchant
    (all_merchant_item_count.sum.to_f / all_merchant_item_count.size).round(2)
  end

  def all_merchant_item_count
    @sales_engine.merchants.all.map do |merchant|
      @sales_engine.merchant_items(merchant.id).length
    end
  end

  def average_items_per_merchant_standard_deviation(merchant_items)
    mean = average_items_per_merchant
    variance = merchant_items.inject(0) do |variance, item_count|
      variance += (item_count - mean) ** 2
    end
    Math.sqrt(variance / (merchant_items.size - 1)).round(2)
    (all_merchant_item_count.values.sum.to_f / all_merchant_item_count.size).round(2)
  end

  def all_merchant_item_count
    merchant_items = Hash.new(0)
    @sales_engine.merchants.all.each do |merchant|
      merchant_items[merchant] = @sales_engine.merchant_items(merchant.id).length
    end
    merchant_items
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    variance = all_merchant_item_count.values.inject(0) do |variance, item_count|
      variance += (item_count - mean) ** 2
    end
    Math.sqrt(variance / (all_merchant_item_count.values.size - 1)).round(2)
  end

  def merchants_with_high_item_count
    merchants = []
    all_merchant_item_count.find_all do |merchant, item_count|
      # if item_count > (average_items_per_merchant_standard_deviation(all_merchant_item_count.values)) + 3
      if item_count > 6
        merchants << merchant
      end
    end
    merchants
  end

  def average_item_price_for_merchant(merchant_id)
    prices = []
    @sales_engine.merchant_items(merchant_id).each do |item|
      prices << item.unit_price_to_dollars
    end
    BigDecimal((prices.sum / prices.size), 4)
  end

  def average_average_price_per_merchant
    all_averages = []
    @sales_engine.merchants.all.each do |merchant|
      all_averages << average_item_price_for_merchant(merchant.id)
    end
    BigDecimal(all_averages.sum / all_averages.size).truncate(2)
  end

  def average_invoices_per_merchant
    ((@sales_engine.numerator_invoices_per_merchant.to_f) / (@sales_engine.all_merchant_invoices.length)).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    numerator = @sales_engine.all_merchant_invoices.sum do |merchant_invoice_count|
      (merchant_invoice_count - mean) ** 2
    end
    (Math.sqrt(numerator / (@sales_engine.all_merchant_invoices.length - 1))).round(2)
  end
end
