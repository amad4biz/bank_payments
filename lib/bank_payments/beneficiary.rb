module BankPayments
  class Beneficiary

    # Required regular fields
    attr_accessor :name, :address, :country_code

    # The BIC (Bank Identification Code) for countires within EU
    attr_accessor :bank_id

    # Can be empty for European payments
    attr_accessor :bank_name

    # IBAN
    attr_accessor :account

  end
end