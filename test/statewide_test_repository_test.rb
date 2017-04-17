require 'minitest/autorun'
require './lib/statewide_test_repository'
require './lib/statewide_test'

class StatewideTestRepositoryTest < Minitest::Test
  def test_statewide_test_setup
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    statewide_test = str.find_by_name("ACADEMY 20")
    assert_instance_of StatewideTest, statewide_test
  end
end
