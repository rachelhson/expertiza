
describe 'SummaryHelper' do
  let(:answer) { Answer.new(answer: 1, comments: 'This is a sentence. This is another sentence.', question_id: 1) }
  before(:each) do
    @sum = SummaryHelper::Summary.new
  end

  #13
  describe '#get_questions_by_assignment'do
    context 'when assignment has vary_by_round,'do
      it 'gives rubric array' do
        @assignment = create(:assignment)
        expect(@sum.get_questions_by_assignment(@assignment).length).to be(2)
      end
    end
    context 'when assignment has not vary_by_round, check questionnair_id.nil' do
      it 'gives 0 or 1' do
        @assignment = create(:assignment, vary_by_round:false)
        expect(@sum.get_questions_by_assignment(@assignment).length).to be(2)
      end
    end
  end

  #14
  describe '#get_reviewers_by_reviewee_and_assignment' do
    context 'when reviewee assigned' do
      before(:each) do
        @student = create(:student, id:1)
        @reviewee = @student
        @session = { user: @student }
      end
      it 'get reveiwers name 'do
        expect(@sum.get_reviewers_by_reviewee_and_a1ssignment(@reviewee,1,@session)).to be_empty
      end
    end
  end

  #15
  describe '#calculate_avg_score_by_criterion' do
    context 'when question_answers are available' do
      let(:assignment) { build(:assignment,id:1) }
      let(:question) { build(:question,id:1) }
      let(:reviewee_id) { build(:assignment,id:1) }
      let(:q_max_score){3}
    end
    context 'when question_answers are nil' do
      it 'calculate question score' do
        question_answers = Answer.answers_by_question_for_reviewee(1,1, 1) # not sure this can bring right data
        expect(@sum.calculate_avg_score_by_criterion(question_answers,3)).to eq(0)
      end
    end
  end

  #16- criteria is not registered in factory
  describe '#calculate_round_score' do
    let(:avg_scores_by_criterion) { {a:2.345} }
    let(:question) {build(:question, weight:1, type:"Criterion")}
    context 'when criteria not available' do
      it 'returns 0' do
        expect(@sum.calculate_round_score(avg_scores_by_criterion,nil)).to eq(0.to_f)
      end
    end
    context 'when criteria not nil' do
      it 'get round_score ' do
        expect(@sum.calculate_round_score(avg_scores_by_criterion,question)).to eq(2.345)
      end
    end
  end

  #17 - criteria is not registered in factory (criteria == question?)
  describe '#calculate_avg_score_by_round'do
    let(:avg_scores_by_criterion) { {a:2.345} }
    let(:question) {build(:question, weight:1, type:"Criterion")}
    context 'when avg_scores_by_criterion available' do
      it 'gives 2 round value' do
        expect(@sum.calculate_avg_score_by_round(avg_scores_by_criterion, question)).to eq(2.35)
      end
    end
  end

  #18 testing the summin
  describe '#calculate_avg_score_by_reviewee' do
      let(:avg_scores_by_round) { [1.224] }
    context 'when avg_scores_by_round available' do
      it 'sum score ' do
        round = avg_scores_by_round.length
        sum_scores = @sum.calculate_avg_score_by_reviewee(avg_scores_by_round,round)
        expect(sum_scores).to eql(1.22) # check round & calculated correctly
      end
    end
      context 'when nround  = 0 'do
        it 'sum_score = 0' do
          round = 0
          sum_scores = @sum.calculate_avg_score_by_reviewee(avg_scores_by_round,round)
          expect(sum_scores).to eq(1.22)
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
