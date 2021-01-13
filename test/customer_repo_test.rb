require './test/test_helper'
require 'pry'
require './lib/customer_repo'

class CustomerRepositoryTest < MiniTest::Test

  def setup
    @engine = "engine"
    @cr = CustomerRepository.new (@engine)
  end

  def test_it_exists_with_attributes
    assert_instance_of CustomerRepository, @cr
    assert_equal @engine, @cr.engine
    assert_equal "#<CustomerRepository 1000 rows>", @cr.inspect
  end

  def test_building_a_customer
    assert_equal 1, @cr.customers[1].id
    assert_equal "Lempi", @cr.customers[369].first_name
    refute_equal "Trevor", @cr.customers[2].last_name
  end

  def test_all
    assert_equal 1000, @cr.all.length
    assert_equal Customer, @cr.all.first.class
  end

  def test_find_by_id
    assert_equal "Joey", @cr.find_by_id(1).first_name
    refute_equal 100, @cr.find_by_id(21).id
    assert_nil @cr.find_by_id(100001)    
    assert_equal Customer, @cr.find_by_id(10).class
  end

  def test_find_all_by_first_name
    assert_equal 8, @cr.find_all_by_first_name("OE").length
    assert_equal "Joey", @cr.find_all_by_first_name("Joey")[0].first_name
  end

  def test_find_all_by_last_name
    assert_equal 3, @cr.find_all_by_last_name("Ondricka").length
    assert_equal 14, @cr.find_all_by_last_name("OE").length
    assert_equal 0, @cr.find_all_by_last_name("Ondrike").length
  end

  def test_max_id
    assert_equal 1000, @cr.max_id
    refute_equal 10, @cr.max_id
  end

  def test_create
    cust = {
      :first_name => "Joan",
      :last_name => "Clarke",
      :created_at => Time.now,
      :updated_at => Time.now
      }
    assert_equal 1000, @cr.max_id
    @cr.create(cust)
    assert_equal "Joan", @cr.customers[1001].first_name
    assert_equal 1001, @cr.max_id
  end

  def test_update
    @cr.update(2,{first_name: "Joe"})
    @cr.update(3,{last_name: "Budina"})
    @cr.update(1, {first_name: "Trevor", last_name: "Suter", created_at: "to"})
    assert_equal "Trevor", @cr.customers[1].first_name
    assert_equal "Suter", @cr.customers[1].last_name
    refute_equal "to", @cr.customers[1].created_at
    customer = @cr.customers[1]
    assert_equal true, @cr.customers.keys.include?(1)
    assert_equal customer, @cr.customers[1]
    @cr.delete(1)
    refute_equal customer, @cr.customers[1]
    assert_equal false, @cr.customers.keys.include?(1)
  end
end