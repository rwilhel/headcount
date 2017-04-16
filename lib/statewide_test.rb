class StatewideTest
  attr_reader :third_grade_organized_data, :eighth_grade_organized_data, :average_math_proficiency_by_ethnicity, :average_reading_proficiency_by_ethnicity, :average_writing_proficiency_by_ethnicity
  def initialize(third_grade_scores, eighth_grade_scores, average_math_proficiency_by_ethnicity, average_reading_proficiency_by_ethnicity, average_writing_proficiency_by_ethnicity)
    @third_grade_scores = third_grade_scores
    @eighth_grade_scores = eighth_grade_scores
    @average_math_proficiency_by_ethnicity = average_math_proficiency_by_ethnicity
    @average_reading_proficiency_by_ethnicity = average_reading_proficiency_by_ethnicity
    @average_writing_proficiency_by_ethnicity = average_writing_proficiency_by_ethnicity
  end
end
