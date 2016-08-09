module BankPayments
  module SwedbankExport

    # There can be two types of monetary records in a transaction. Payments and
    # credits sent over to the bank. This is the parent class that describes both.
    # There is a date present which means different things depending on which
    # implementation that is being used.
    #
    # @author Michael Litton
    class MoneyRecord < SpisuRecord

      define_field :serial_number,  '2:8:N'
      define_field :reference_msg,  '9:33:AN'
      define_field :amount_sek,     '34:44:N'
      define_field :amount_foreign, '66:78:N'
      define_field :currency_code,  '55:57:AN'
      define_field :date,           '58:63:N'

    end
  end
end
