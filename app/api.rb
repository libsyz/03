require 'sinatra/base'
require 'json'
require_relative 'ledger'

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

      if result.success?
        JSON.generate(expense_id: result.expense_id)
      else
        status 422
        JSON.generate(error: result.error_message)
      end
    end

    get '/expenses/:date' do
      JSON.generate([])
    end
  end
end
