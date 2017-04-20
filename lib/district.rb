require 'pry'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

class District

  attr_reader :name, :enrollment, :statewide_test, :economic_profile

  def initialize(args)
    @name = args[:name]
    initialize_enrollment
    initialize_statewide_test
    initialize_economic_profile
  end

  def initialize_enrollment
    enrollment_repository = EnrollmentRepository.new
    enrollment_repository.load_data({:enrollment => {:kindergarten =>
      "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"}})
    @enrollment = enrollment_repository.find_by_name(name)
  end

  def initialize_statewide_test
    statewide_test_repository = StatewideTestRepository.new
    statewide_test_repository.load_data({:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv",},
      :statewide_testing => {:third_grade =>
      "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }})
    @statewide_test = statewide_test_repository.find_by_name(name)
  end

  def initialize_economic_profile
    epr = EconomicProfileRepository.new
    epr.load_data({:economic_profile => {:median_household_income =>
      "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch =>
      "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"}})
    @economic_profile = epr.find_by_name(name)
  end
end
