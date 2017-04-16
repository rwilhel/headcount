require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test
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

    def test_proficiency_by_race
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
      expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                   2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                   2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                   2014 => {math: 0.800, reading: 0.855, writing: 0.789},
                 }
      result = statewide_test.proficient_by_race_or_ethnicity(:asian)
      assert_equal expected, result

      statewide_test = str.find_by_name("WOODLAND PARK RE-2")
      expected = {2011=>{:math=>0.451, :reading=>0.688, :writing=>0.503},
                  2012=>{:math=>0.467, :reading=>0.75, :writing=>0.528},
                  2013=>{:math=>0.473, :reading=>0.738, :writing=>0.531},
                  2014=>{:math=>0.418, :reading=>0.006, :writing=>0.453}}
      result = statewide_test.proficient_by_race_or_ethnicity(:hispanic)
      assert_equal expected, result

      statewide_test = str.find_by_name("PAWNEE RE-12")
      expected = {2011=>{:math=>0.581, :reading=>0.792, :writing=>0.698},
                  2012=>{:math=>0.452, :reading=>0.773, :writing=>0.622},
                  2013=>{:math=>0.469, :reading=>0.714, :writing=>0.51},
                  2014=>{:math=>0.468, :reading=>0.006, :writing=>0.488}}
      result = statewide_test.proficient_by_race_or_ethnicity(:white)
      assert_equal expected, result
    end
end
