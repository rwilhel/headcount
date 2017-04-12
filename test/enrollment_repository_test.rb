require 'minitest/autorun'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  def test_loading_and_finding_enrollments
    enrollment_repository = EnrollmentRepository.new
    enrollment_repository.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })

    name = "GUNNISON WATERSHED RE1J"
    enrollment = enrollment_repository.find_by_name(name)
    assert_instance_of Enrollment, enrollment
    assert_equal name, enrollment.name
    assert_equal 0.144, enrollment.kindergarten_participation_in_year(2004)

    downcase_name = "gunnison watershed re1j"
    enrollment = enrollment_repository.find_by_name(downcase_name)
    assert_instance_of Enrollment, enrollment
    assert_equal "GUNNISON WATERSHED RE1J", enrollment.name
    assert_equal 0.144, enrollment.kindergarten_participation_in_year(2004)
  end
end
