module BankPayments::SPISU
  class AmountRecord < Record

    define_field :serial_number,  '2:8:N'
    define_field :reference_msg,  '9:33:AN'
    define_field :amount_sek,     '34:44:N'
    define_field :amount_foreign, '66:78:N'
    define_field :currency_code,  '55:57:AN'
    define_field :date,           '58:63:N'

    private

    def format_amount(amount)
      ("%.2f" % amount).gsub(".","")
    end

  end
end


