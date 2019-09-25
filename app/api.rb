require 'sinatra/base'
require 'json'

module ExpenseTracker

  class API < Sinatra::Base

    def initialize(ledger)
      @ledger = ledger
      super
    end
    post '/expenses' do
      # Need to check the params and pass them to the JSON generate
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)
      JSON.generate(expense_id: result.expense_id)
    end

    get '/expenses/:date' do
      JSON.generate([])
    end

  end
end
