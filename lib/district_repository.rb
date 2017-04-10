require 'csv'
require './lib/district'
require 'pry'

class DistrictRepository
  attr_reader :contents

  def load_data(data)
    @contents = CSV.open data[:enrollment][:kindergarten], headers: true, header_converters: :symbol
  end

  def find_by_name(name)
    # binding.pry
    contents.each do |row|
      if row[:location] == name
        district = District.new(row)
        return district
      end
    end
  end

end
