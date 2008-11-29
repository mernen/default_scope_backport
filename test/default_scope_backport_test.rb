require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/models/developer'

class DefaultScopeBackportTest < Test::Unit::TestCase
  load_schema
  load_fixtures

  def test_default_scope
    expected = Developer.find(:all, :order => 'salary DESC').collect { |dev| dev.salary }
    received = DeveloperOrderedBySalary.find(:all).collect { |dev| dev.salary }
    assert_equal expected, received
  end

  def test_default_scoping_with_threads
    scope = [{ :create => {}, :find => { :order => 'salary DESC' } }]

    2.times do
      Thread.new { assert_equal scope, DeveloperOrderedBySalary.send(:scoped_methods) }.join
    end
  end

  def test_default_scoping_with_inheritance
    scope = [{ :create => {}, :find => { :order => 'salary DESC' } }]

    # Inherit a class having a default scope and define a new default scope
    klass = Class.new(DeveloperOrderedBySalary)
    klass.send :default_scope, {}

    # Scopes added on children should append to parent scope
    expected_klass_scope = [{ :create => {}, :find => { :order => 'salary DESC' }}, { :create => {}, :find => {} }]
    assert_equal expected_klass_scope, klass.send(:scoped_methods)
    
    # Parent should still have the original scope
    assert_equal scope, DeveloperOrderedBySalary.send(:scoped_methods)
  end

  def test_method_scope
    expected = Developer.find(:all, :order => 'name DESC').collect { |dev| dev.salary }
    received = DeveloperOrderedBySalary.all_ordered_by_name.collect { |dev| dev.salary }
    assert_equal expected, received
  end

  def test_nested_scope
    expected = Developer.find(:all, :order => 'name DESC').collect { |dev| dev.salary }
    received = DeveloperOrderedBySalary.with_scope(:find => { :order => 'name DESC'}) do
      DeveloperOrderedBySalary.find(:all).collect { |dev| dev.salary }
    end
    assert_equal expected, received
  end

  def test_named_scope
    expected = Developer.find(:all, :order => 'name DESC').collect { |dev| dev.salary }
    received = DeveloperOrderedBySalary.by_name.find(:all).collect { |dev| dev.salary }
    assert_equal expected, received
  end

  def test_nested_exclusive_scope
    expected = Developer.find(:all, :limit => 100).collect { |dev| dev.salary }
    received = DeveloperOrderedBySalary.with_exclusive_scope(:find => { :limit => 100 }) do
      DeveloperOrderedBySalary.find(:all).collect { |dev| dev.salary }
    end
    assert_equal expected, received
  end

  def test_overwriting_default_scope
    expected = Developer.find(:all, :order => 'salary').collect { |dev| dev.salary }
    received = DeveloperOrderedBySalary.find(:all, :order => 'salary').collect { |dev| dev.salary }
    assert_equal expected, received
  end
end
