require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'

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
end
