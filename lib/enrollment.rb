require 'pry'

class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(args)
    @name = args[:name]
    @kindergarten_participation = args[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |key, value|
      kindergarten_participation[key] = (((value*1000).floor).to_f)/1000
    end
    kindergarten_participation
  end
end
