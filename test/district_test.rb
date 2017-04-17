require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'

class DistrictTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv",
                  :high_school_graduation => "./data/High school graduation rates.csv",
                 },
                 :statewide_testing => {
                   :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                   :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                   :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                   :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                   :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                 }
               })
  end

  def test_district_name
    district = District.new({name: "Colorado"})

    assert_equal "Colorado", district.name
  end

  def test_district_enrollment_relationship_basics
    district = dr.find_by_name("GREELEY 6")

    assert_equal 0.042, district.enrollment.kindergarten_participation_in_year(2005)
    assert_instance_of Enrollment, district.enrollment
  end

  def test_statewide_testing_relationships
    district = dr.find_by_name("ACADEMY 20")
    statewide_test = district.statewide_test

    assert_instance_of StatewideTest, statewide_test
  end
end
