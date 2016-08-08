module BankPayments::SwedbankExport
  class PaymentRecord < MoneyRecord

    def initialize
      super
      self.type = '6'
    end

    def amount_sek=(amount)
      super amount.spisu_format
    end

    def amount_foreign=(amount)
      super amount.spisu_format
    end

  end
end


