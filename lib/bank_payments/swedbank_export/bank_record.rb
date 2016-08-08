module BankPayments::SwedbankExport
  class BankRecord < Record

    define_field :serial_number, '2:8:N'

    # Usually BIC (Bank Identification Code)
    define_field :bank_id,       '9:20:AN'

    # IBAN (Internactional Bank Account Number)
    define_field :account,       '21:50:AN'

    # Leave this blank if the payment is made within EU
    define_field :name,          '51:80:AN'

    def initialize
      super
      self.type = '4'
    end
  end
end
