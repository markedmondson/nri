require 'csv'

class QuestionPicker
  attr_accessor :strands, :csv_questions, :questions, :chosen_strands, :chosen_standards, :chosen_questions

  def initialize(file_path=nil)
    if file_path
      load_questions(file_path)
      load_strands
      sort_questions
    end

    @chosen_questions ||= []
    @chosen_strands ||= []
    @chosen_standards ||= Hash.new { |h, k| h[k] = Array.new }
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

  # Pick a strand from the remaining choices, store the choice
  # @return [Integer] strand
  #
  def pick_strand
    strand = (strands.keys - chosen_strands).sample
    chosen_strands << strand
    strand
  end

  # Pick a standard from the remaining choices for this strand
  # @param [Integer] strand
  # @return [Integer] standard
  # TODO: change .sample to .shift when sorted by difficulty
  #
  def pick_standard(strand)
    standard = (strands[strand] - chosen_standards[strand]).sample
    chosen_standards[strand] << standard
    standard
  end

  # Pick a question from the remaining choices for this strand and standard
  # @param [Integer] strand
  # @param [Integer] standard
  # @return [Integer] question
  #
    def pick_question(strand, standard)
    # Pop a question
    remaining_questions = questions[strand][standard]
    question = remaining_questions.delete_at(rand(remaining_questions.size - 1))
    chosen_questions << question
    question
  end

  # Pick questions
  # @return [Array<Integer>]
  #
  def pick_questions(count)
    raise ArgumentError, "Count must be greater than 1" if count < 1

    (0..count-1).each do |i|
      # Return early if strands is empty
      break if strands.empty?

      strand = pick_strand
      standard = pick_standard(strand)
      question = pick_question(strand, standard)

      # TODO reset strands when picked from both
      # TODO reset standards when picked from both

      if ENV['DEBUG']
        puts "strand: #{strand}, standard: #{standard}, question: #{question}"
        puts questions
        puts strands
      end
    end

    chosen_questions
  end
end
