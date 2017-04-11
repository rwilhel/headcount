require 'csv'
require './lib/district'
require 'pry'

class DistrictRepository
  attr_reader :all

  def load_data(data)
    contents = CSV.open data[:enrollment][:kindergarten], headers:
    true, header_converters: :symbol
    @all = contents.to_a
  end

  def find_by_name(name)
    name = name.upcase
    all.each do |row|
      if row[:location] == name
        district = District.new({name: row[:location]})
        return district
      end
    end
  end

  def find_all_matching(name_fragment)
    name_fragment = name_fragment.upcase
    districts = []
    all.each do |row|
      # if the row name includes the fragment
        # if districts is empty
          # add that district to districts
        # elsif districts does not contain a district with that name
          # add that district to districts
        # elsif districts contains a district with that same name
          #do nothing and move on.
      if row[:location].include?(name_fragment)
        if districts.empty?
          district = District.new({name: row[:location]})
          districts << district
        elsif !districts_contains_name?(districts, row[:location])
          district = District.new({name: row[:location]})
          districts << district
        end
      end
    end
    districts
  end

  def districts_contains_name?(districts, district_name)
    districts.any? do |district|
      district.name == district_name
    end
  end
end
