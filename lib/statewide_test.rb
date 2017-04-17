require_relative 'custom_errors'

class StatewideTest
  attr_reader :third_grade_scores, :eighth_grade_scores, :proficiency_by_race
  def initialize(third_grade_scores, eighth_grade_scores, average_math_proficiency_by_race, average_reading_proficiency_by_race, average_writing_proficiency_by_race)
    @third_grade_scores = third_grade_scores
    @eighth_grade_scores = eighth_grade_scores
    @proficiency_by_race = {}
    @proficiency_by_race[:math] = average_math_proficiency_by_race
    @proficiency_by_race[:reading] = average_reading_proficiency_by_race
    @proficiency_by_race[:writing] = average_writing_proficiency_by_race
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

  def proficient_by_race_or_ethnicity(race)
    race = format_race(race)

    data_for_one_race_by_subject = get_data_for_race_by_subject(race, proficiency_by_race)

    scores_by_year = create_hash_with_year_keys(data_for_one_race_by_subject)

    final_results = populate_data_by_subject(scores_by_year, data_for_one_race_by_subject)
  end

  def format_race(race)
    raise UnknownRaceError if ![:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white].include? race
    race = "Asian" if race == :asian
    race = "Black" if race == :black
    race = "Hawaiian/Pacific Islander" if race == :pacific_islander
    race = "Hispanic" if race == :hispanic
    race = "Native American" if race == :native_american
    race = "Two or more" if race == :two_or_more
    race = "White" if race == :white
    race
  end

  def get_data_for_race_by_subject(race, proficiency_by_race)
    data_for_one_race_by_subject = {}
    proficiency_by_race.each do |subject, dataset|
      data_for_one_race_by_subject[subject] = []
      dataset.each do |row|
        if row[:ethnicity] == race
          data_for_one_race_by_subject[subject] << row
        end
      end
    end
    data_for_one_race_by_subject
  end

  def create_hash_with_year_keys(data_for_one_race_by_subject)
    final_results = {}
    data_for_one_race_by_subject.each do |subject, dataset|
      dataset.each do |race_year_score|
        year = race_year_score[:year]
        final_results[year] = {}
      end
    end
    final_results
  end

  def populate_data_by_subject(scores_by_year, data_for_one_race_by_subject)
    data_for_one_race_by_subject.each do |subject, dataset|
      dataset.each do |race_year_score|
        year = race_year_score[:year]
        score = race_year_score[:score]
        scores_by_year[year][subject] = score
      end
    end
    scores_by_year
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    # subject is a symbol. grade is a fixnum. year is a fixnum.
    raise UnknownDataError if ![:math, :reading, :writing].include? subject
    math_reading_writing_by_year = proficient_by_grade(grade)
    score = math_reading_writing_by_year[year][subject]
    return "N/A" if score == 0.0
    score
  end
end
