require 'pry'
require_relative 'enrollment_repository'

class District

  attr_reader :name, :enrollment

  def initialize(args)
    @name = args[:name]
    initialize_enrollment
  end

  def initialize_enrollment
    enrollment_repository = EnrollmentRepository.new
    enrollment_repository.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    @enrollment = enrollment_repository.find_by_name(name)
  end
end
