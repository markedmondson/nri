require_relative 'lib/question_picker'

require 'pry'

def ask_questions
  puts "Enter number of questions (please enter a number): "
  count = gets.chomp.to_i
  count == 0 ? ask_questions : count
end

count = ask_questions
puts "Generating #{count} questions..."

question_ids = QuestionPicker.new.pick_questions(count)
puts "Question IDs: " + question_ids.to_s
