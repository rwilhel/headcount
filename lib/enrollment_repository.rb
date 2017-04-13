require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :all
  def load_data(data)
    contents = CSV.open data[:enrollment][:kindergarten], headers: true,
    header_converters: :symbol
    @all = contents.to_a
  end

  def find_by_name(name)
    name = name.upcase
    enrollment_year_and_data = {}
    all.each do |row|
      if row[:location].upcase == name
        data = row[:data].to_f
        key = row[:timeframe].to_i
        enrollment_year_and_data[key] = data
      end
    end
  enrollment_arguments = {:name => name, :kindergarten_participation =>
    enrollment_year_and_data}
  enrollment = Enrollment.new(enrollment_arguments)
  end
end
