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
      return math_reading_writing_by_year(third_grade_scores)
    elsif grade == 8
      return math_reading_writing_by_year(eighth_grade_scores)
    else
      return nil
    end
  end

  def math_reading_writing_by_year(scores)
    scores_by_year = organize_scores_by_year(scores)
    math_reading_writing = organize_scores_by_subject(scores_by_year)
  end

  def organize_scores_by_year(scores)
    organized_scores = scores.group_by do |subject_year_score|
      subject_year_score[:year]
    end
    organized_scores
  end

  def organize_scores_by_subject(scores_by_year)
    math_reading_writing = {}
    scores_by_year.each do |year, subject_year_score_for_one_year|
      math_reading_writing[year] = {}
      subject_year_score_for_one_year.each do |subject_year_score|
        save_data_by_subject(subject_year_score, math_reading_writing, year)
      end
    end
    math_reading_writing
  end

  def save_data_by_subject(subject_year_score, math_reading_writing, year)
    if is_math_data?(subject_year_score)
      save_math_data(subject_year_score, math_reading_writing, year)
    elsif is_reading_data?(subject_year_score)
      save_reading_data(subject_year_score, math_reading_writing, year)
    elsif is_writing_data?(subject_year_score)
      save_writing_data(subject_year_score, math_reading_writing, year)
    end
  end

  def is_math_data?(subject_year_score)
    subject_year_score[:subject] == "Math"
  end

  def is_reading_data?(subject_year_score)
    subject_year_score[:subject] == "Reading"
  end

  def is_writing_data?(subject_year_score)
    subject_year_score[:subject] == "Writing"
  end

  def save_math_data(subject_year_score, math_reading_writing, year)
    math_score = subject_year_score[:score]
    math_reading_writing[year][:math] = math_score
  end

  def save_reading_data(subject_year_score, math_reading_writing, year)
    reading_score = subject_year_score[:score]
    math_reading_writing[year][:reading] = reading_score
  end

  def save_writing_data(subject_year_score, math_reading_writing, year)
    writing_score = subject_year_score[:score]
    math_reading_writing[year][:writing] = writing_score
  end
end
