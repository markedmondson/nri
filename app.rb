require_relative 'lib/question_picker'

require 'pry'

CSV_FILE = File.expand_path 'db/seeds_data/questions.csv'

def ask_questions
  puts "Enter number of questions (please enter a number): "
  count = gets.chomp.to_i
  count == 0 ? ask_questions : count
end

question_picker = QuestionPicker.new(CSV_FILE)

count = ask_questions
puts "Generating #{count} questions..."

question_ids = question_picker.pick_questions(count)
puts "Question IDs: " + question_ids.to_s
