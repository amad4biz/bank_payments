module BankPayments::SwedbankExport

  # Lookup module for account types as described in the specification from
  # the bank making calling code a little bit easier to understand.
  module AccountType
    DEPOSIT_ACCOUNT  = 0
    CURRENCY_ACCOUNT = 1
  end

  # @see AccountType
  module Priority
    NORMAL    = 0
    EXPRESS   = 1
    CHECK     = 2
  end

  # @see AccountType
  module CostResponsibility
    PAYER        = 0
    OWN_EXPENSES = 2
  end
end
