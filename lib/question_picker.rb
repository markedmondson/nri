require 'csv'

class QuestionPicker
  attr_accessor :strands, :csv_questions, :questions

  def initialize(file_path=nil)
    if file_path
      load_questions(file_path)
      load_strands
      sort_questions
    end
  end

  # Load questions from CSV file
  # @return [CSV::Table]
  #
  def load_questions(file_path)
    @csv_questions = CSV.read(file_path, headers: true, header_converters: :symbol, converters: :all)
  end

  # TODO
  #
  def sort_questions
    # @questions = questions.sort! { |a, b| a[:difficulty] <=> b[:difficulty] }
  end

  # Transform to strand => [standards] hash eg.
  # { 1 => [1, 2, 3], 2 => [4, 5] }
  # @return [Hash]
  #
  def load_strands
    @strands = csv_questions.inject(Hash.new { |h, k| h[k] = Array.new }) do |memo, question|
      memo[question[:strand_id]] << question[:standard_id]
      memo[question[:strand_id]].uniq!
      memo
    end
    @strands
  end

  # Convert the questions into a hash
  # {
  #   <strand-id> =>
  #     <standard-id> => [<question-ids>]
  # }
  # @return [Hash]
  #
  def questions
    @questions ||= csv_questions.reduce(Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = Array.new } }) do |memo, question|
      strand = question[:strand_id]
      standard = question[:standard_id]

      memo[strand][standard] << question[:question_id]
      memo
    end
    @questions
  end

  # Pick questions
  # @return [Array<Integer>]
  #
  def pick_questions(count)
    return [1, 2, 3]
  end
end
