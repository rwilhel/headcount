class StatewideTest
  attr_reader :third_grade_scores, :eighth_grade_scores, :average_math_proficiency_by_ethnicity, :average_reading_proficiency_by_ethnicity, :average_writing_proficiency_by_ethnicity
  def initialize(third_grade_scores, eighth_grade_scores, average_math_proficiency_by_ethnicity, average_reading_proficiency_by_ethnicity, average_writing_proficiency_by_ethnicity)
    @third_grade_scores = third_grade_scores
    @eighth_grade_scores = eighth_grade_scores
    @average_math_proficiency_by_ethnicity = average_math_proficiency_by_ethnicity
    @average_reading_proficiency_by_ethnicity = average_reading_proficiency_by_ethnicity
    @average_writing_proficiency_by_ethnicity = average_writing_proficiency_by_ethnicity
  end

  def proficient_by_grade(grade)
    if grade == 3
      third_grade_scores_by_year = third_grade_scores.group_by do |subject_year_score|
        subject_year_score[:year]
      end

      math_reading_writing = {}

      third_grade_scores_by_year.each do |year, subject_year_score_for_one_year|
        math_reading_writing[year] = {}
        subject_year_score_for_one_year.each do |subject_year_score|
          if subject_year_score[:subject] == "Math"
            math_score = subject_year_score[:score]
            math_reading_writing[year][:math] = math_score
          elsif subject_year_score[:subject] == "Reading"
            reading_score = subject_year_score[:score]
            math_reading_writing[year][:reading] = reading_score
          elsif subject_year_score[:subject] == "Writing"
            writing_score = subject_year_score[:score]
            math_reading_writing[year][:writing] = writing_score
          end
        end
      end
      return math_reading_writing
    elsif grade == 8
      eighth_grade_scores_by_year = eighth_grade_scores.group_by do |subject_year_score|
        subject_year_score[:year]
      end

      math_reading_writing = {}

      eighth_grade_scores_by_year.each do |year, subject_year_score_for_one_year|
        math_reading_writing[year] = {}
        subject_year_score_for_one_year.each do |subject_year_score|
          if subject_year_score[:subject] == "Math"
            math_score = subject_year_score[:score]
            math_reading_writing[year][:math] = math_score
          elsif subject_year_score[:subject] == "Reading"
            reading_score = subject_year_score[:score]
            math_reading_writing[year][:reading] = reading_score
          elsif subject_year_score[:subject] == "Writing"
            writing_score = subject_year_score[:score]
            math_reading_writing[year][:writing] = writing_score
          end
        end
      end
      return math_reading_writing
    else
      return nil
    end
  end
end
