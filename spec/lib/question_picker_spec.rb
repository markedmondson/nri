require_relative '../spec_helper'

require_relative '../../lib/question_picker'

describe QuestionPicker do
  let(:picker)    { described_class.new }
  let(:strands)   {
    {
      1 => [1, 2],
      2 => [3]
    }
  }
  let(:questions) {
    {
      1 => {
        1 => [1, 2],
        2 => [3]
      },
      2 => {
        3 => [4]
      }
    }
  }

  before do
    picker.questions = questions
    picker.strands   = strands
  end

  describe '#load_questions' do
    let(:file_path) { File.expand_path 'spec/fixtures/questions.csv' }

    it 'should return a CSV::Table' do
      expect(picker.load_questions(file_path)).to be_a CSV::Table
    end
  end

  describe '#sort_questions' do
    xit 'should order the questions by difficulty' do

    end
  end

  describe '#load_strands' do
    let(:csv_questions) {
      [
        {
          strand_id: 1,
          standard_id: 1,
          question_id: 1
        },
        {
          strand_id: 1,
          standard_id: 2,
          question_id: 2
        }
      ]
    }

    before { picker.csv_questions = csv_questions }

    it 'should return a hash of { strand => [standards] }' do
      expect(picker.load_strands).to eq({ 1 => [1, 2] })
    end
  end

  describe '#questions' do
    it 'should return a hash of { strand => {standard: [questions]} }' do
      expect(picker.questions).to eq(
        { 1 =>
          {
            1 => [1, 2],
            2 => [3]
          },
          2 =>
          {
            3  => [4]
          }
        }
      )
    end
  end

  describe '#pick_questions' do
    it 'should return an array of questions' do
      expect(picker.pick_questions(4)).to contain_exactly(1, 2, 3)
    end
  end
end
