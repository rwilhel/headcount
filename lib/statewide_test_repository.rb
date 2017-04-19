require 'csv'
require 'pry'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :information, :eighth_grade_raw_data, :average_math_proficiency_by_ethnicity_raw_data, :average_reading_proficiency_by_ethnicity_raw_data, :average_writing_proficiency_by_ethnicity_raw_data
  def load_data(data)
    @information = {}
    @information[:third_grade_raw_data] = get_third_grade_raw_data(data)
    @information[:eighth_grade_raw_data] = get_eighth_grade_raw_data(data)
    @information[:average_math_proficiency_by_ethnicity_raw_data] = get_average_math_proficiency_by_ethnicity_raw_data(data)
    @information[:average_reading_proficiency_by_ethnicity_raw_data] =  get_average_reading_proficiency_by_ethnicity_raw_data(data)
    @information[:average_writing_proficiency_by_ethnicity_raw_data] = get_average_writing_proficiency_by_ethnicity_raw_data(data)
  end

  def find_by_name(name)
    name = name.upcase
    third_grade_scores = set_third_grade_scores(name)
    eighth_grade_scores = set_third_grade_scores(name)
    average_math_proficiency_by_ethnicity = set_average_math_proficiency_by_ethnicity(name)
    average_reading_proficiency_by_ethnicity = set_average_reading_proficiency_by_ethnicity(name)
    average_writing_proficiency_by_ethnicity = set_average_writing_proficiency_by_ethnicity(name)
    statewide_test = StatewideTest.new(third_grade_scores, eighth_grade_scores, average_math_proficiency_by_ethnicity, average_reading_proficiency_by_ethnicity, average_writing_proficiency_by_ethnicity)
  end

  def get_third_grade_raw_data(data)
    third_grade_raw_data = CSV.open data[:statewide_testing][:third_grade], headers: true, header_converters: :symbol
    third_grade_raw_data.to_a
  end

  def get_eighth_grade_raw_data(data)
    eighth_grade_raw_data = CSV.open data[:statewide_testing][:eighth_grade], headers: true, header_converters: :symbol
    eighth_grade_raw_data.to_a
  end

  def get_average_math_proficiency_by_ethnicity_raw_data(data)
    average_math_proficiency_by_ethnicity_raw_data = CSV.open data[:statewide_testing][:math], headers: true, header_converters: :symbol
    average_math_proficiency_by_ethnicity_raw_data.to_a
  end

  def get_average_reading_proficiency_by_ethnicity_raw_data(data)
    average_reading_proficiency_by_ethnicity_raw_data = CSV.open data[:statewide_testing][:reading], headers: true, header_converters: :symbol
    average_reading_proficiency_by_ethnicity_raw_data.to_a
  end

  def get_average_writing_proficiency_by_ethnicity_raw_data(data)
    average_writing_proficiency_by_ethnicity_raw_data = CSV.open data[:statewide_testing][:writing], headers: true, header_converters: :symbol
    @average_writing_proficiency_by_ethnicity_raw_data = average_writing_proficiency_by_ethnicity_raw_data.to_a
  end

  def set_third_grade_scores(name)
    third_grade_scores = []
    information[:third_grade_raw_data].each do |row|
      if row[:location].upcase == name
        subject = row[:score]
        year = row[:timeframe].to_i
        score = row[:data].to_f
        score = (((score*1000).floor).to_f)/1000
        third_grade_scores << {:subject => subject, :year => year, :score => score}
      end
    end
  end

  def set_eighth_grade_scores(name)
    eighth_grade_scores = []
    information[:eighth_grade_raw_data].each do |row|
      if row[:location].upcase == name
        subject = row[:score]
        year = row[:timeframe].to_i
        score = row[:data].to_f
        score = (((score*1000).floor).to_f)/1000
        eighth_grade_scores << {:subject => subject, :year => year, :score => score}
      end
    end
  end

  def set_average_math_proficiency_by_ethnicity(name)
    average_math_proficiency_by_ethnicity = []
    information[:average_math_proficiency_by_ethnicity_raw_data].each do |row|
      if row[:location].upcase == name
        ethnicity = row[:race_ethnicity]
        year = row[:timeframe].to_i
        score = row[:data].to_f
        score = (((score*1000).floor).to_f)/1000
        average_math_proficiency_by_ethnicity << {:ethnicity => ethnicity, :year => year, :score => score}
      end
    end
  end

  def set_average_reading_proficiency_by_ethnicity(name)
    average_reading_proficiency_by_ethnicity = []
    information[:average_reading_proficiency_by_ethnicity_raw_data].each do |row|
      if row[:location].upcase == name
        ethnicity = row[:race_ethnicity]
        year = row[:timeframe].to_i
        score = row[:data].to_f
        score = (((score*1000).floor).to_f)/1000
        average_reading_proficiency_by_ethnicity << {:ethnicity => ethnicity, :year => year, :score => score}
      end
    end
  end

  def set_average_writing_proficiency_by_ethnicity(name)
    average_writing_proficiency_by_ethnicity = []
    information[:average_writing_proficiency_by_ethnicity_raw_data].each do |row|
      if row[:location].upcase == name
        ethnicity = row[:race_ethnicity]
        year = row[:timeframe].to_i
        score = row[:data].to_f
        score = (((score*1000).floor).to_f)/1000
        average_writing_proficiency_by_ethnicity << {:ethnicity => ethnicity, :year => year, :score => score}
      end
    end
  end
end
