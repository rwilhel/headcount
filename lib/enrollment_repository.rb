require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :kindergarten_all, :high_school_all
  def load_data(data)

    @kindergarten_all = set_all_kindergarten_data(data)

    @high_school_all = set_all_high_school_data(data)
  end

  def set_all_kindergarten_data(data)
    if data[:enrollment][:kindergarten]
      kindergarten_contents = CSV.open data[:enrollment][:kindergarten],
        headers: true, header_converters: :symbol
      kindergarten_all = kindergarten_contents.to_a
    else
      kindergarten_all = []
    end
  end

  def set_all_high_school_data(data)
    if data[:enrollment][:high_school_graduation]
      high_school_contents = CSV.open
        data[:enrollment][:high_school_graduation], headers: true,
        header_converters: :symbol
      @high_school_all = high_school_contents.to_a
    else
      @high_school_all = []
    end
  end

  def find_by_name(name)
    name = name.upcase
    enrollment_year_and_data = set_enrollment_data(kindergarten_all, name)
    graduation_year_and_data = set_high_school_data(high_school_all, name)
  enrollment_arguments = {:name => name,
    :kindergarten_participation =>enrollment_year_and_data,
    :high_school_graduation => graduation_year_and_data}
  enrollment = Enrollment.new(enrollment_arguments)
  end

  def set_enrollment_data(kindergarten_all, name)
    enrollment_year_and_data = {}
    kindergarten_all.each do |row|
      if row[:location].upcase == name
        data, key = get_data_and_key_from(row)
        enrollment_year_and_data[key] = data
      end
    end
    enrollment_year_and_data
  end

  def set_high_school_data(high_school_all, name)
    graduation_year_and_data = {}
    high_school_all.each do |row|
      if row[:location].upcase == name
        data, key = get_data_and_key_from(row)
        graduation_year_and_data[key] = data
      end
    end
    graduation_year_and_data
  end

  def get_data_and_key_from(row)
    data = row[:data].to_f
    key = row[:timeframe].to_i
    [data, key]
  end
end
