require 'pry'

class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
    district_repository.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
  end

  def kindergarten_participation_rate_variation(district_name, comparison_district_hash)
    average_participation = average_kindergarten_participation_for(district_name)

    comparison_district_name = comparison_district_hash[:against]
    comparison_average_participation = average_kindergarten_participation_for(comparison_district_name)

    ratio = average_participation / comparison_average_participation
    ratio = (((ratio*1000).floor).to_f)/1000
  end

  def average_kindergarten_participation_for(district_name)
    district = district_repository.find_by_name(district_name)
    enrollment_by_year = district.enrollment.kindergarten_participation_by_year
    average_participation = get_average(enrollment_by_year)
    average_participation = (((average_participation*1000).floor).to_f)/1000
  end

  def get_average(data_by_year)
    sum = 0
    count = 0
    data_by_year.each_value do |value|
      sum += value
      count += 1
    end
    average_data = sum/count
  end

  def kindergarten_participation_rate_variation_trend(district_name, comparison_district_hash)
    enrollment_by_year = district_enrollment_by_year(district_name)

    comparison_district_name = comparison_district_hash[:against]
    comparison_enrollment_by_year = district_enrollment_by_year(comparison_district_name)

    results = get_ratio_for_each_year(enrollment_by_year, comparison_enrollment_by_year)

    results = Hash[results.sort_by {|key, value| key.to_i}]
  end

  def district_enrollment_by_year(district_name)
    district = district_repository.find_by_name(district_name)
    enrollment_by_year = district.enrollment.kindergarten_participation
  end

  def get_ratio_for_each_year(enrollment_by_year, comparison_enrollment_by_year)
    results = {}
    enrollment_by_year.each do |key, value|
      comparison_value = comparison_enrollment_by_year[key]
      result = value / comparison_value
      result = (((result*1000).floor).to_f)/1000
      results[key] = result
    end
    results
  end

  def average_high_school_graduation_rate_for(district_name)
    district = district_repository.find_by_name(district_name)
    graduation_rate_by_year = district.enrollment.graduation_rate_by_year
    average_graduation_rate = get_average(graduation_rate_by_year)
    average_graduation_rate = (((average_graduation_rate*1000).floor).to_f)/1000
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    #divide kindergarten participation by statewide average
    kindergarten_variation = kindergarten_participation_rate_variation(district_name, {:against => "COLORADO"})
    graduation_variation =
    #we have the average high school graduation rate for a district and we need to find the state average graduation rate
    #we will divide those numbers
  end
end
