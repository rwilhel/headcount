require 'pry'

class District

  attr_reader :name

  def initialize(row)
    @name = row[:location]
  end
end
