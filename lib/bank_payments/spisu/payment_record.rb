module BankPayments::SPISU
  class PaymentRecord < AmountRecord

    def initialize
      super
      self.type = '6'
    end

    def amount_sek=(amount)
      super format_amount(amount)
    end

    def amount_foreign=(amount)
      super format_amount(amount)
    end

  end
end


