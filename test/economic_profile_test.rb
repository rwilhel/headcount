require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require './lib/economic_profile_repository'
require './lib/custom_errors'

class EconomicProfileTest < Minitest::Test


  def test_economic_profile_basics
    data = {:median_household_income => {[2005, 2009] => 85060, [2006, 2010] => 85450},
            :children_in_poverty => {2012 => 0.064},
            :free_or_reduced_price_lunch => {2014 => {:percentage => 0.127, :total => 3132}},
            :title_i => {2014 => 0.027},
            :name => "ACADEMY 20"
           }
    ep = EconomicProfile.new(data)

    assert_instance_of EconomicProfile, ep
  end

  def test_median_household_income_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
                    :economic_profile => {
                      :median_household_income => "./data/Median household income.csv",
                      :children_in_poverty => "./data/School-aged children in poverty.csv",
                      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                      :title_i => "./data/Title I students.csv"
                    }
                  })
    economic_profile = epr.find_by_name("ACADEMY 20")

    assert_equal 88279, economic_profile.median_household_income_in_year(2010)
    assert_raises(UnknownDataError){economic_profile.median_household_income_in_year(1)}
  end

  def test_for_median_household_income_average
    epr = EconomicProfileRepository.new
    epr.load_data({
                    :economic_profile => {
                      :median_household_income => "./data/Median household income.csv",
                      :children_in_poverty => "./data/School-aged children in poverty.csv",
                      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                      :title_i => "./data/Title I students.csv"
                    }
                  })
    economic_profile = epr.find_by_name("ACADEMY 20")

    assert_equal 87635, economic_profile.median_household_income_average
  end

  def test_it_can_find_children_in_poverty_in_given_year
    epr = EconomicProfileRepository.new
    epr.load_data({
                    :economic_profile => {
                      :median_household_income => "./data/Median household income.csv",
                      :children_in_poverty => "./data/School-aged children in poverty.csv",
                      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                      :title_i => "./data/Title I students.csv"
                    }
                  })
    economic_profile = epr.find_by_name("ACADEMY 20")

    assert_equal 0.064, economic_profile.children_in_poverty_in_year(2012)
  end
end
