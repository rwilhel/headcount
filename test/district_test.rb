require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_district_name
    district = District.new({name: "Colorado"})

    assert_equal "Colorado", district.name
  end
end
