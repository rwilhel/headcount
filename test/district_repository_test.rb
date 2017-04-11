require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    upcase_district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", upcase_district.name

    downcase_district = dr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", downcase_district.name


    # assert_equal 7, dr.find_all_matching("WE").count
  end

end
