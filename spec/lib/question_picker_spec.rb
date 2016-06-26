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
    let(:csv_questions) {
      [
        {
          strand_id: 1,
          standard_id: 1,
          question_id: 1,
          difficulty: 0.8
        },
        {
          strand_id: 1,
          standard_id: 1,
          question_id: 2,
          difficulty: 0.2
        }
      ]
    }

    before { picker.csv_questions = csv_questions }

    before do
      picker.questions = nil
      picker.sort_questions
    end

    it 'should order the questions by difficulty' do
      expect(picker.questions).to eq({ 1 => { 1 => [2, 1] }})
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

  describe '#pick_strand' do
    it 'should return a valid strand' do
      expect([1, 2]).to include picker.pick_strand
    end

    it 'should add the picked strand to an array' do
      strand = picker.pick_strand

      expect(picker.chosen_strands).to eq [strand]
    end

    context 'when one strand has already been chosen' do
      before { picker.chosen_strands = [1] }

      it 'should pick from unique strands' do
        expect(picker.pick_strand).to eq 2
      end
    end
  end

  describe '#pick_standard' do
    before { picker.strands = strands }

    it 'should pick from the pass strand' do
      expect(picker.pick_standard(2)).to eq 3
    end

    it 'should add the picked standard to an array' do
      picker.pick_standard(2)

      expect(picker.chosen_standards).to eq({ 2 => [3] })
    end

    context 'when one standard has already been chosen' do
      before { picker.chosen_standards = { 1 => [1] } }

      it 'should pick from unique standards' do
        expect(picker.pick_standard(1)).to eq 2
      end
    end
  end

  describe '#pick_questions' do
    context 'if there are no strands setup' do
      let(:strands) { {} }

      it 'should return empty array' do
        expect(picker.pick_questions(4)).to eq []
      end
    end

    it 'should return an array of questions' do
      expect(picker.pick_questions(4)).to contain_exactly(1, 2, 3, 4)
    end
  end
end
