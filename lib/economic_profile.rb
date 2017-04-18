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
    sum = incomes.inject(0) { |income, sum| sum + income }
    average = sum/incomes.length
  end
end
