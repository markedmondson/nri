require_relative '../spec_helper'

require_relative '../../lib/question_picker'

describe QuestionPicker do
  describe '#pick_questions' do
    it 'should return an array of questions' do
      expect(picker.pick_questions(4)).to contain_exactly(1, 2, 3)
    end
  end
end
