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

    def send_expense
      post '/expenses', JSON.generate(expense)
    end

    before do
      allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
    end


    describe 'POST expenses' do
      context 'when the expense is successfully recorded' do
        it 'returns the expense id' do
          send_expense
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          send_expense
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
          send_expense
          expect(last_response.body).to include("Expense Incomplete")
        end

        it 'responds with a 422 (Unprocessable Entity)' do
          send_expense
          expect(last_response.status).to eq 422
        end
      end
    end

    describe 'GET expenses' do
      context 'when the expenses exist on the given date' do
        let(:date) { "2014-03-11" }

        before do
          allow(ledger).to receive(:query)
            .with(date).and_return([{expense_id: 123,
                                   payee: "Starbucks",
                                   amount: 12.23}])
        end

        it 'returns an array of hashes containing the expenses' do
          get "/expenses/#{date}"
          expect(last_response.body).to include("123")
        end
        it 'returns a 200 (OK) status' do
          get "/expenses/#{date}"
          expect(last_response.status).to eq 200
        end
      end

      context 'when the expenses do not exist on the given date' do
        let(:date) { "2014-03-11" }

        before do
          allow(ledger).to receive(:query)
            .with(date).and_return([])
        end

        it 'returns an empty array as JSON' do
          get "expenses/#{date}"
          parsed = JSON.parse(last_response.body)
          expect(parsed).to be_empty
        end

        it 'responds with a 200 (OK) status' do
          get "expenses/#{date}"
          expect(last_response.status).to eq 200
        end
      end
    end
  end
end
