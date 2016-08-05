module BankPayments::SPISU

  module AccountType
    DEPOSIT_ACCOUNT  = 0
    CURRENCY_ACCOUNT = 1
  end

  module Priority
    NORMAL    = 0
    EXPRESS   = 1
    CHECK     = 2
  end

  module CostResponsibility
    PAYER        = 0
    OWN_EXPENSES = 2
  end
end
