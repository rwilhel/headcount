require 'CSV'
require 'pry'

class EconomicProfileRepository

  def load_data(data)
    @information = {}

    median_household_income = CSV.open data[:economic_profile][:median_household_income], headers: true, header_converters: :symbol
    @information[:median_household_income] = median_household_income.to_a

    children_in_poverty = CSV.open data[:economic_profile][:children_in_poverty], headers: true, header_converters: :symbol
    @information[:children_in_poverty] = children_in_poverty.to_a

    free_or_reduced_price_lunch = CSV.open data[:economic_profile][:free_or_reduced_price_lunch], headers: true, header_converters: :symbol
    @information[:free_or_reduced_price_lunch] = free_or_reduced_price_lunch.to_a
    title_i = CSV.open data[:economic_profile][:title_i], headers: true, header_converters: :symbol
    @information[:title_i] = title_i.to_a
  end

  def find_by_name(name)
    name = name.upcase
    instantiation_data = data_structure_for_economic_profile(name)
    @information.each do |data_label, data_set|
      data_set.each do |row|
        if row[:location].upcase == name
          format_data(row, instantiation_data, data_label)
        end
      end
    end
    EconomicProfile.new(instantiation_data)
  end

  def data_structure_for_economic_profile(name)
    instantiation_data = {}
    instantiation_data[:median_household_income] = {}
    instantiation_data[:children_in_poverty] = {}
    instantiation_data[:free_or_reduced_price_lunch] = {}
    instantiation_data[:title_i] = {}
    instantiation_data[:name] = name
    instantiation_data
  end

  def format_data(row, instantiation_data, data_label)
    case data_label
    when :median_household_income
      format_median_household_income_data(row, instantiation_data)
    when :children_in_poverty
      format_children_in_poverty_data(row, instantiation_data)
    when :free_or_reduced_price_lunch && is_eligible_for_free_or_reduced_lunch?(row)
      format_free_or_reduced_price_lunch_data(row, instantiation_data)
      format_percent_or_number_data(row, instantiation_data)
    when :title_i
      format_title_i_data(row, instantiation_data)
    end
  end

  def format_date_range(date_range)
    dates = date_range.split("-")
    dates.map { |date| date.to_i }
  end

  def format_median_household_income_data(row, instantiation_data)
    date_range = format_date_range(row[:timeframe])
    instantiation_data[:median_household_income][date_range] = row[:data].to_i
  end

  def format_children_in_poverty_data(row, instantiation_data)
    date = row[:timeframe].to_i
    instantiation_data[:children_in_poverty][date] = row[:data].to_f
  end

  def is_eligible_for_free_or_reduced_lunch?(row)
    row[:poverty_level] == "Eligible for Free or Reduced Lunch"
  end

  def format_free_or_reduced_price_lunch_data(row, instantiation_data)
    date = row[:timeframe].to_i
    instantiation_data[:free_or_reduced_price_lunch][date] = {} if !instantiation_data[:free_or_reduced_price_lunch][date]
  end

  def format_percent_or_number_data(row, instantiation_data)
    if row[:dataformat] == "Percent"
      instantiation_data[:free_or_reduced_price_lunch][date][:percentage] = row[:data].to_f
    elsif row[:dataformat] == "Number"
      instantiation_data[:free_or_reduced_price_lunch][date][:total] = row[:data].to_f
    end
  end

  def format_title_i_data(row, instantiation_data)
    date = row[:timeframe].to_i
    instantiation_data[:title_i][date] = row[:data].to_f
  end
end
