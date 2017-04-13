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

  def test_enrollment_repository_with_high_school_data
      er = EnrollmentRepository.new
      er.load_data({
                     :enrollment => {
                       :kindergarten => "./data/Kindergartners in full-day program.csv",
                       :high_school_graduation => "./data/High school graduation rates.csv"
                     }
                   })
      e = er.find_by_name("MONTROSE COUNTY RE-1J")

      # assert_equal 0.738, e.graduation_rate_in_year(2010)

      expected = {2010=>0.738, 2011=>0.751, 2012=>0.777, 2013=>0.713, 2014=>0.757}
      assert_equal expected, e.graduation_rate_by_year
    end
end
