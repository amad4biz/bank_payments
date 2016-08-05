module BankPayments
  class InternationalPayment

    # The serial number is unique per payee. It must be managed by the
    # payment itself since it is an implementation detail of of the
    # underlying format. We might even move this to the file generator
    attr_accessor :serial_number

    def initialize(payer, beneficiary, date, currency, amount)

    end
  end
end

