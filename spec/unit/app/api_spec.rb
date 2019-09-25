require_relative '../../../app/api'
require 'rspec'
require 'rack/test'
require 'pry'

module ExpenseTracker

  RSpec.describe API do
    include Rack::Test::Methods

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:expense) { { "some" => "data" } }

    def app
      API.new(ledger)
    end

    before do
      allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
    end


    describe 'POST expenses' do
      context 'when the expense is successfully recorded' do
        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { {"some" => "data"} }
        before do
          allow(ledger).to receive(:record)
            .with(expense).and_return(RecordResult.new(false, 417, "Expense Incomplete"))
        end
        it 'returns an error message' do
          post "/expenses", JSON.generate(expense)
          expect(last_response.body).to include("Expense Incomplete")
        end

        it 'responds with a 422 (Unprocessable Entity)' do
          post "/expenses", JSON.generate(expense)
          expect(last_response.status).to eq 422
        end
      end
    end
  end
end
