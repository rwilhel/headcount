require 'pry'

class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district_name, comparison_district_hash)
    district_repository.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    district = district_repository.find_by_name(district_name)
    enrollment_by_year = district.enrollment.kindergarten_participation_by_year
    average_participation = get_average(enrollment_by_year)
    average_participation = (((average_participation*1000).floor).to_f)/1000

    comparison_district = district_repository.find_by_name(comparison_district_hash[:against])
    comparison_enrollment_by_year = comparison_district.enrollment.kindergarten_participation_by_year
    comparison_average_participation = get_average(comparison_enrollment_by_year)
    comparison_average_participation = (((comparison_average_participation*1000).floor).to_f)/1000

    ratio = average_participation / comparison_average_participation
    ratio = (((ratio*1000).floor).to_f)/1000
  end

  def get_average(enrollment_by_year)
    sum = 0
    count = 0
    enrollment_by_year.each_value do |value|
      sum += value
      count += 1
    end
    average_participation = sum/count
  end

  def kindergarten_participation_rate_variation_trend(district_name, comparison_district_hash)
    district_repository.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    district = district_repository.find_by_name(district_name)
    enrollment_by_year = district.enrollment.kindergarten_participation

    comparison_district = district_repository.find_by_name(comparison_district_hash[:against])
    comparison_enrollment_by_year = comparison_district.enrollment.kindergarten_participation

    results = {}

    enrollment_by_year.each do |key, value|
      comparison_value = comparison_enrollment_by_year[key]
      result = value / comparison_value
      result = (((result*1000).floor).to_f)/1000
      results[key] = result
    end
    results = Hash[results.sort_by {|key, value| key.to_i}]
  end
end
