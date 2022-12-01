require 'rack/test'

require_relative '../../../app/api'
 	
module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods
	
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    
    def app
      API.new(ledger: ledger)
    end

    def expect_to_include(parsed, hash)
      expect(parsed).to include(hash)
    end
	
    describe 'POST /expenses' do
      let(:expense) { { 'some' => 'data' } }

      context 'when the expense is successfully recorded' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do          
          post '/expenses', JSON.generate(expense)
        
          parsed = JSON.parse(last_response.body)
          expect_to_include(parsed, 'expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(200)
        end
      end
            
      context 'when the expense fails validation' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
 	
          parsed = JSON.parse(last_response.body)
          expect_to_include(parsed, 'error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end
    
    describe 'GET /expenses/:date' do
      let(:expenses) { [{ 'some' => 'data' }, {'some_other' => 'data'} ] }

      context 'when expenses exist on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-11-27')
            .and_return([RecordResult.new(true, 417, nil),
                         RecordResult.new(true, 418, nil)
                         ])
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2017-11-27'

          parsed_body = JSON.parse(last_response.body)
          parsed_body.each { |i| expect(i["expense_id"]).to_not be_nil }
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2017-11-27'

          expect(last_response.status).to eq(200)
        end
      end
    
      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on).with('2017-11-28').and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2017-11-28'

          parsed_body = JSON.parse(last_response.body)
          expect(parsed_body).to be_empty
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2017-11-28'

          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end