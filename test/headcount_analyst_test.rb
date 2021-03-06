require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  #
  # def test_enrollment_analysis_basics
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 1.126, ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
  #   assert_equal 1.126, ha.kindergarten_participation_rate_variation("gunnison watershed re1j", :against => "telluride r-1")
  #   assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  #   assert_equal 0.766, ha.kindergarten_participation_rate_variation('academy 20', :against => 'colorado')
  #
  #   expected_result = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
  #   assert_equal expected_result, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  # end
  #
  # def test_kindergarten_participation_against_high_school_graduation
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
  #                                 :high_school_graduation => "./data/High school graduation rates.csv"}})
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J')
  #   assert_equal 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2')
  # end
  #
  # def test_does_kindergarten_participation_predict_hs_graduation
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
  #                                 :high_school_graduation => "./data/High school graduation rates.csv"}})
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'ACADEMY 20')
  #   refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'MONTROSE COUNTY RE-1J')
  #   refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'SIERRA GRANDE R-30')
  #   assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'PARK (ESTES PARK) R-3')
  # end
  #
  # def test_statewide_kindergarten_high_school_prediction
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
  #                                 :high_school_graduation => "./data/High school graduation rates.csv"}})
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  # end
  #
  # def test_kindergarten_hs_prediction_multi_district
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
  #                                 :high_school_graduation => "./data/High school graduation rates.csv"}})
  #   ha = HeadcountAnalyst.new(dr)
  #   districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
  #   assert ha.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  # end

  def test_finding_top_overall_districts
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
    ha = HeadcountAnalyst.new(dr)
    #
    # assert_raises(InsufficientInformationError) {ha.top_statewide_test_year_over_year_growth(subject: :math)}
    # assert_raises(UnknownDataError) {ha.top_statewide_test_year_over_year_growth(grade: 9)}
    #
    # assert_equal ["SPRINGFIELD RE-4", 0.149], ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    # assert_equal ["WELDON VALLEY RE-20(J)", 0.096], ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)
    #
    # assert_equal [["SPRINGFIELD RE-4", 0.149], ["WESTMINSTER 50", 0.1], ["CENTENNIAL R-1", 0.088]], ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
binding.pry
    assert_equal "SANGRE DE CRISTO RE-22J", ha.top_statewide_test_year_over_year_growth(grade: 3).first
    # assert_equal 0.071, ha.top_statewide_test_year_over_year_growth(grade: 3).last
    #
    # assert_equal "OURAY R-1", ha.top_statewide_test_year_over_year_growth(grade: 8).first
    # assert_equal 0.11, ha.top_statewide_test_year_over_year_growth(grade: 8).last
  end
end
