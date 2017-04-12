require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_name
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_returns_kindergarten_participation_by_year
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal({2010 => 0.391, 2011 => 0.353, 2012 => 0.267}, enrollment.kindergarten_participation_by_year)
  end

  def test_returns_kindergarten_participation_in_year
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, enrollment.test_returns_kindergarten_participation_in_year(2010)
  end
end
