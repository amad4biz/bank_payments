module BankPayments::SwedbankExport

  # Describes the beneficiaries / payees bank. All fields are required except
  # for the name which is only required is the payment is made outside of EU.
  # This is something that any implementors needs to validate on their own.
  #
  # @author Michael Litton
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
