require 'csv'

class QuestionPicker
  attr_accessor :questions

  def initialize(file_path)
    load_questions(file_path)
  end

  # Load questions from CSV file
  # @return [CSV::Table]
  #
  def load_questions(file_path)
    @questions = CSV.read(file_path, headers: true, header_converters: :symbol, converters: :all)
  end


  # Pick questions
  # @return [Array<Integer>]
  #
  def pick_questions(count)
    return [1, 2, 3]
  end
end
