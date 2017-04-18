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
    instantiation_data = {}
    instantiation_data[:median_household_income] = {}
    instantiation_data[:children_in_poverty] = {}
    instantiation_data[:free_or_reduced_price_lunch] = {}
    instantiation_data[:title_i] = {}
    @information.each do |data_label, data|
      data.each do |row|
        if row[:location].upcase == name
          if data_label == :median_household_income
            date_range = format_date_range(row[:timeframe])
            instantiation_data[:median_household_income][date_range] = row[:data].to_i
          elsif data_label == :children_in_poverty
            date = row[:timeframe].to_i
            instantiation_data[:children_in_poverty][date] = row[:data].to_f
          elsif data_label == :free_or_reduced_price_lunch && row[:poverty_level].include?(" or ")
            date = row[:timeframe].to_i
            instantiation_data[:free_or_reduced_price_lunch][date] = {} if !instantiation_data[:free_or_reduced_price_lunch][date]
            if row[:dataformat] == "Percent"
              instantiation_data[:free_or_reduced_price_lunch][date][:percentage] = row[:data].to_f
            elsif row[:dataformat] == "Number"
              instantiation_data[:free_or_reduced_price_lunch][date][:total] = row[:data].to_f
            end
          elsif data_label == :title_i
            date = row[:timeframe].to_i
            instantiation_data[:title_i][date] = row[:data].to_f
          end
          instantiation_data[:name] = name
        end
      end
    end
    EconomicProfile.new(instantiation_data)
  end

  def format_date_range(date_range)
    dates = date_range.split("-")
    dates.map { |date| date.to_i }
  end
end
