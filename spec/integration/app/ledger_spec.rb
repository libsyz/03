require_relative '../../../app/ledger'
require_relative '../../../config/sequel'
require_relative '../../support/db'
require 'pry'

module ExpenseTracker
  RSpec.describe Ledger do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        'payee' => "Starbucks",
        'amount' => 5.75,
        'date' => '21-10-19'
      }
    end

    after(:example) do
      # Gotta clean up the DB
      DB[:expenses].delete
    end

    describe '#record' do
      context 'with a valid expense' do
        it 'records the expense in the expenses table', :aggregate_failures do
          result = ledger.record(expense)
          expect(result).to be_success
          expect(DB[:expenses].all).to eq([{ amount: 5.75,
            date: Date.iso8601('21-10-19'),
            id: result.expense_id,
            payee: 'Starbucks'
          }])
        end

        context 'with an invalid expense' do
          let(:expense) do
            {
              "payee" => nil,
              "amount" => 5.75,
              "date" => nil
            }
          end

          it 'does not record anything on the DB', :aggregate_failures do
            result = ledger.record(expense)
            expect(result).not_to be_success
            expect(result.error_message).to eq 'expense data is incomplete'
            expect(DB[:expenses].all.size).to eq 0
          end
        end
      end
    end
  end
end
