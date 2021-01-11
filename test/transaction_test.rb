require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require 'pry'
require './lib/transaction'

class TestTransaction < Minitest::Test
  def setup
    @transaction = Transaction.new({
      :id => 6,
      :invoice_id => 8,
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date => "0220",
      :result => "success",
      :created_at => Time.now,
      :updated_at => Time.now
    })
  end

  def test_it_exists_with_attributes
    assert_instance_of Transaction, @transaction
    assert_equal 6, @transaction.id
    assert_equal 8, @transaction.invoice_id
    assert_equal "4242424242424242", @transaction.credit_card_number
    assert_equal "0220", @transaction.credit_card_expiration_date
    assert_equal "success", @transaction.result
  end
end