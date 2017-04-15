require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repository'

class HeadcountAnalystTest < Minitest::Test

  def test_enrollment_analysis_basics
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 1.126, ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    assert_equal 1.126, ha.kindergarten_participation_rate_variation("gunnison watershed re1j", :against => "telluride r-1")
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('academy 20', :against => 'colorado')

    expected_result = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
    assert_equal expected_result, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_against_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                  :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J')
    assert_equal 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2')
  end

  def test_does_kindergarten_participation_predict_hs_graduation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                  :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'ACADEMY 20')
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'MONTROSE COUNTY RE-1J')
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'SIERRA GRANDE R-30')
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'PARK (ESTES PARK) R-3')
  end

  def test_statewide_kindergarten_high_school_prediction
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                  :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end
end
