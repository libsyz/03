
require 'rack/test'
require 'sinatra/base'
require 'json'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    class API

    end

    def app
      ExpenseTracker::API.new
    end

    it 'records submitted expenses' do
      coffee = {
        payee: 'Starbucks',
        amount: 5.75,
        date: '2017-06-19'
        }

        post 'expenses', JSON.generate(coffee)
    end


  end
end
