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
        # I would expect the table to contain the expense
      end

      context 'with an invalid expense' do
        it 'does not record anything on the DB'
        it 'throws an error'
      end


      end
    end
  end
end
