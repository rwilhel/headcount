require 'pry'

class Enrollment
  attr_reader :name, :kindergarten_participation, :high_school_graduation

  def initialize(args)
    @name = args[:name]
    @kindergarten_participation = args[:kindergarten_participation]
    @high_school_graduation = args[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |key, value|
      kindergarten_participation[key] = (((value*1000).floor).to_f)/1000
    end
    kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    raw_number = kindergarten_participation[year]
    formatted_number = (((raw_number*1000).floor).to_f)/1000
  end

  def graduation_rate_by_year
    high_school_graduation.each do |key, value|
      high_school_graduation[key] = (((value*1000).floor).to_f)/1000
    end
    high_school_graduation
  end
end
