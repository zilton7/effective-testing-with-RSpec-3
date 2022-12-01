require 'sinatra/base'
require 'json'

require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    get '/expenses/:date' do
      date = params[:date]
      result = @ledger.expenses_on(date)


      if result.size > 0
        JSON.generate(result)
      elsif result.size == 0
        JSON.generate([])
      end
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end
  end
end