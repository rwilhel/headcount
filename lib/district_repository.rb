require 'csv'
require './lib/district'
require 'pry'

class DistrictRepository
  attr_reader :contents

  def load_data(data)
    @contents = CSV.open data[:enrollment][:kindergarten], headers: true, header_converters: :symbol
  end

  def find_by_name(name)
    contents.each do |row|
      if row[:location] == name
        district = District.new({name: name})
        return district
      end
    end
  end

end
