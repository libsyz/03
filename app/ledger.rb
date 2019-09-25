
module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  class Ledger
    def record(expense)
      if valid?(expense)
        DB[:expenses].insert(expense)
        id = DB[:expenses].max(:id)
        RecordResult.new(true, id, nil)
      else
        RecordResult.new(false, nil, "expense data is incomplete")
      end

    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end


    private

    def valid?(expense)
      expense['payee'] &&
      expense['amount'] &&
      expense['date']
    end
  end
end
