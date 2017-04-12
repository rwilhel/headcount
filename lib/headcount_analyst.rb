require 'pry'

class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district_name, comparison_district)
    district_repository.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    district = district_repository.find_by_name(district_name)
    enrollment_by_year = district.enrollment.kindergarten_participation_by_year
    sum = 0
    count = 0
    enrollment_by_year.each_value do |value|
      sum += value
      count += 1
    end
    average_participation = sum/count
  end
end
