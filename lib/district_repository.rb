require 'csv'
require_relative 'district'
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
      if row[:location].upcase == name
        district = District.new({name: row[:location]})
        return district
      end
    end
    return nil
  end

  def find_all_matching(name_fragment)
    name_fragment = name_fragment.upcase
    districts = []
    all.each do |row|
      if row[:location].upcase.include?(name_fragment)
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
