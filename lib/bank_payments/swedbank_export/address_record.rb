module BankPayments::SwedbankExport
  class AddressRecord < Record

    define_field :serial_number, '2:8:N'
    define_field :address,       '9:73:AN'
    define_field :country_code,  '75:76:AN'

    # Account type to use
    # '0': Inlåningskonto (SEK-konto)
    # '1': Valutakonto
    define_field :account_type,  '74:74:N'

    # Transaction cost responsibility
    # '2': The beneficiary is responsible for their transaction costs
    # '0': The payer stands for all transaction costs
    define_field :cost_carrier, '78:78:N'

    # Priority code
    # '0': Normal
    # '1': Express
    # '2': Check
    define_field :priority, '80:80:N'

    def initialize
      super
      self.type = '3'
    end

  end
end
