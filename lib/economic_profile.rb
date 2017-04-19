require './lib/custom_errors'

class EconomicProfile
  attr_reader :data
  def initialize(instantiation_data)
    @data = instantiation_data
  end

  def median_household_income_in_year(year)
    incomes = []
    data[:median_household_income].each do |year_range, income|
      if year >= year_range.first && year <= year_range.last
        incomes << income
      end
    end
    raise UnknownDataError if incomes.empty?
    sum = incomes.inject(0) { |income, sum| sum + income }
    average = sum/incomes.length
  end

  def median_household_income_average
    incomes = data[:median_household_income].values
    sum = incomes.inject(0) { |income, sum| sum + income }
    average = sum/incomes.length
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError if data[:children_in_poverty][year].nil?
    data[:children_in_poverty][year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError if data[:free_or_reduced_price_lunch][year].nil?
    data[:free_or_reduced_price_lunch][year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError if data[:free_or_reduced_price_lunch][year].nil?
    data[:free_or_reduced_price_lunch][year][:total].to_i
  end

  def title_i_in_year(year)
    raise UnknownDataError if data[:title_i][year].nil?
    data[:title_i][year]
  end
end
