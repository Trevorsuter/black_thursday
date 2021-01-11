require 'CSV'
require_relative './transaction'
class TransactionRepository
  attr_reader :engine, :file
  attr_accessor :transactions

  def initialize(file = './data/transactions.csv', engine)
    @engine = engine
    @file = file
    @transactions = {}
    make_transactions(CSV.readlines(@file, headers: true, header_converters: :symbol))
  end

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end

  def make_transactions(data)
    data.each do |row|
      transactions[row[:id].to_i] = Transaction.new({id: row[:id].to_i,
                                                    invoice_id: row[:invoice_id].to_i,
                                                    credit_card_number: row[:credit_card_number],
                                                    credit_card_expiration_date: row[:credit_card_expiration_date],
                                                    result: row[:result].to_sym,
                                                    created_at: row[:created_at],
                                                    updated_at: row[:updated_at]})
    end
  end

  def all
    transactions.values
  end

  def find_by_id(id)
    transactions[id]
  end

  def find_all_by_invoice_id(invoice)
    all.find_all do |transaction|
      invoice == transaction.invoice_id
    end
  end

  def find_all_by_credit_card_number(num)
    all.find_all do |transaction|
      num.to_s == transaction.credit_card_number
    end
  end

  def find_all_by_result(result)
    all.find_all do |transaction|
      result == transaction.result
    end
  end

  def max_id
    transactions.keys.max
  end

  def create(attributes)
    new = Transaction.new(attributes)
    new.id = (max_id + 1)
    transactions[new.id] = new
  end

  def update(id, attributes)
    transactions[id].credit_card_number = attributes[:credit_card_number] if attributes[:credit_card_number]
    transactions[id].credit_card_expiration_date = attributes[:credit_card_expiration_date] if attributes[:credit_card_expiration_date]
    transactions[id].result = attributes[:result] if attributes[:result]
  end

  def delete(id)
    transactions.delete(id)
  end
end