require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_name
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal "ACADEMY 20", enrollment.name 
  end
end
