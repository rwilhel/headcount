require 'minitest/autorun'
require './lib/statewide_test_repository'
require './lib/statewide_test'

class StatewideTestRepositoryTest < Minitest::Test
  def test_proficiency_by_grade
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

    expected_third_grade_scores = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
               }
    assert_equal expected_third_grade_scores, statewide_test.proficient_by_grade(3)

    expected_eighth_grade_scores = { 2008 => {:math => 0.640, :reading => 0.843, :writing => 0.734},
                 2009 => {:math => 0.656, :reading => 0.825, :writing => 0.701},
                 2010 => {:math => 0.672, :reading => 0.863, :writing => 0.754},
                 2011 => {:math => 0.653, :reading => 0.832, :writing => 0.745},
                 2012 => {:math => 0.681, :reading => 0.833, :writing => 0.738},
                 2013 => {:math => 0.661, :reading => 0.852, :writing => 0.750},
                 2014 => {:math => 0.684, :reading => 0.827, :writing => 0.747}
               }
    assert_equal expected_eighth_grade_scores, statewide_test.proficient_by_grade(8)

    assert_equal nil, statewide_test.proficient_by_grade(4)
  end
end
