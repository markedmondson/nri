require_relative '../spec_helper'

require_relative '../../lib/question_picker'

describe QuestionPicker do
  let(:picker)    { described_class.new }
  describe '#load_questions' do
    let(:file_path) { File.expand_path 'spec/fixtures/questions.csv' }

    it 'should return a CSV::Table' do
      expect(picker.load_questions(file_path)).to be_a CSV::Table
    end
  end

  describe '#pick_questions' do
    it 'should return an array of questions' do
      expect(picker.pick_questions(4)).to contain_exactly(1, 2, 3)
    end
  end
end
