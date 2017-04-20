require 'pry'
require_relative 'custom_errors'

class HeadcountAnalyst
  attr_reader :district_repository, :third_grade_raw_data, :eighth_grade_raw_data

  def initialize(district_repository)
    @district_repository = district_repository
    district_repository.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    initialize_statewide_test_repository
  end

  def initialize_statewide_test_repository
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
    @third_grade_raw_data = str.third_grade_raw_data
    @eighth_grade_raw_data = str.eighth_grade_raw_data
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
    kindergarten_variation = kindergarten_participation_rate_variation(district_name, {:against => "COLORADO"})

    district_graduation_rate = average_high_school_graduation_rate_for(district_name)
    colorado_graduation_rate = average_high_school_graduation_rate_for("COLORADO")

    graduation_variation = district_graduation_rate / colorado_graduation_rate
    graduation_variation = (((graduation_variation*1000).floor).to_f)/1000

    if graduation_variation == 0.0
      return 0.0
    end
    kindergarten_graduation_variance = kindergarten_variation / graduation_variation
    kindergarten_graduation_variance = (((kindergarten_graduation_variance*1000).floor).to_f)/1000
  end

  def kindergarten_participation_correlates_with_high_school_graduation(input_hash)
    if input_hash[:for] && input_hash[:for] != "STATEWIDE"
      kindergarten_graduation_variance = kindergarten_participation_against_high_school_graduation(input_hash[:for])
      if kindergarten_graduation_variance > 0.6 && kindergarten_graduation_variance < 1.5
        return true
      else
        return false
      end
    elsif input_hash[:across]
      # find correlation across the several supplied districts
      district_names = input_hash[:across]
      correlation_counter = 0
      district_names.each do |name|
        correlates = kindergarten_participation_correlates_with_high_school_graduation(:for => name)
          if correlates
            correlation_counter += 1
          end
      end
      if correlation_counter / district_names.length > 0.7
        return true
      else
        return false
      end
    else
      # find correlation across every district
      correlation_counter = 0
      district_names = get_all_districts
      district_names.each do |name|
        correlates = kindergarten_participation_correlates_with_high_school_graduation(:for => name)
          if correlates
            correlation_counter += 1
          end
      end
      if correlation_counter / district_names.length > 0.7
        return true
      else
        return false
      end
    end
  end

  def get_all_districts
    district_names = []
    district_repository.all.each do |row|
      if row[:location] != "Colorado" && !district_names.include?(row[:location])
        district_names << row[:location]
      end
    end
    district_names
  end

  def top_statewide_test_year_over_year_growth(input)
    grade = input[:grade]
    subject = input[:subject].to_s.capitalize
    subject = :all if subject == ""
    top_amount = input[:top] || 1
    raise InsufficientInformationError if grade.nil?
    raise UnknownDataError if grade != 3 && grade != 8
    if grade == 3
      result = get_top_third_grade_test_year_over_year_growth(subject, top_amount)
    elsif grade == 8
      result = get_top_eighth_grade_test_year_over_year_growth(subject, top_amount)
    end
    result
  end

  def get_top_third_grade_test_year_over_year_growth(subject, top_amount)
    data_by_district = third_grade_raw_data.group_by do |row|
       row[:location]
    end
    if subject == :all
      three_subject_growth_rates = []
      subjects = ["Math", "Reading", "Writing"]
      subjects.each do |subject|
        scores = get_scores_for_all_districts(subject, data_by_district)
        growth_rates = get_growth_rates_for_all_districts(scores)
        three_subject_growth_rates << growth_rates
      end
      math_growth_rates = three_subject_growth_rates[0]
      reading_growth_rates = three_subject_growth_rates[1]
      writing_growth_rates = three_subject_growth_rates[2]
      growth_rates_added_for_all_subjects = {}
      (math_growth_rates.keys | reading_growth_rates.keys | writing_growth_rates.keys).each do |key|
        growth_rates_added_for_all_subjects[key] = math_growth_rates[key] + reading_growth_rates[key] + writing_growth_rates[key]
      end
      growth_rates = {}
      growth_rates_added_for_all_subjects.each do |key, value|
        value = value / 3
        value = (((value*1000).floor).to_f)/1000
        growth_rates[key] = value
      end
    else
      scores = get_scores_for_all_districts(subject, data_by_district)
      growth_rates = get_growth_rates_for_all_districts(scores)
    end
    if top_amount == 1
      max_growth_district_and_growth_rate = growth_rates.max_by { |key, value| value }
      binding.pry
    else
      sorted_growth_rates = growth_rates.sort_by {|k, v| v}
      top_growth_rates = sorted_growth_rates[-top_amount..-1].reverse
    end
  end

  def get_top_eighth_grade_test_year_over_year_growth(subject, top_amount)
    data_by_district = eighth_grade_raw_data.group_by do |row|
       row[:location]
    end
    if subject == :all
      three_subject_growth_rates = []
      subjects = ["Math", "Reading", "Writing"]
      subjects.each do |subject|
        scores = get_scores_for_all_districts(subject, data_by_district)
        growth_rates = get_growth_rates_for_all_districts(scores)
        three_subject_growth_rates << growth_rates
      end
      math_growth_rates = three_subject_growth_rates[0]
      reading_growth_rates = three_subject_growth_rates[1]
      writing_growth_rates = three_subject_growth_rates[2]
      growth_rates_added_for_all_subjects = {}
      (math_growth_rates.keys | reading_growth_rates.keys | writing_growth_rates.keys).each do |key|
        growth_rates_added_for_all_subjects[key] = math_growth_rates[key] + reading_growth_rates[key] + writing_growth_rates[key]
      end
      growth_rates = {}
      growth_rates_added_for_all_subjects.each do |key, value|
        value = value / 3
        value = (((value*1000).floor).to_f)/1000
        growth_rates[key] = value
      end
    else
      scores = get_scores_for_all_districts(subject, data_by_district)
      growth_rates = get_growth_rates_for_all_districts(scores)
    end
    if top_amount == 1
      binding.pry
      max_growth_district_and_growth_rate = growth_rates.max_by { |key, value| value }
    else
      sorted_growth_rates = growth_rates.sort_by {|k, v| v}
      top_growth_rates = sorted_growth_rates[-top_amount..-1].reverse
    end
  end

  def get_scores_for_all_districts(subject, data_by_district)
    scores = {}
    data_by_district.each do |district_name, data_for_one_district|
      scores[district_name] = []
      data_for_one_district.each do |row|
        year = row[:timeframe].to_i
        data = row[:data].to_f
        scores[district_name] << [year, data] if row[:score] == subject
      end
    end
    scores
  end

  def get_growth_rates_for_all_districts(scores)
    growth_rates = {}
    scores.each do |district_name, year_data_pairs|
      beginning_year = year_data_pairs.first.first
      beginning_data = year_data_pairs.first.last
      end_year = year_data_pairs.last.first
      end_data = year_data_pairs.last.last
      growth_rate = (end_data - beginning_data)/(end_year - beginning_year)
      growth_rate = (((growth_rate*1000).floor).to_f)/1000
      growth_rates[district_name] = growth_rate
    end
    growth_rates
  end
end
