describe 'SummaryHelper' do
  let(:answer) { Answer.new(answer: 1, comments: 'This is a sentence. This is another sentence.', question_id: 1) }
  before(:each) do
    @sum = SummaryHelper::Summary.new
  end

  describe '#calculate_avg_score_by_reviewee' do
    context 'when avg_scores_by_round available' do
      it 'sum score ' do
        sum_scores = @sum.calculate_avg_score_by_reviewee([1,2,3,4,5],5)
        expect(sum_scores).to eql(3.to_f)
      end
    end
  end

  describe '#get_sentences' do
    context 'when the answer is nil' do
      it 'returns a nil object' do
        expect(@sum.get_sentences(nil)).to eq(nil)
      end
    end
    context 'when the comment is two sentences' do
      it 'returns an array of two sentences' do
        sentences = @sum.get_sentences(answer)
        expect(sentences.length).to be(2)
      end
    end
  end
end
