module BankPayments
  module SwedbankImport
    class MoneyRecord < SpisuRecord

      define_field :serial_number,      '2:8:N'
      define_field :reference,          '9:33:AN'
      define_field :amount_sek,         '34:44:N'
      define_field :bank_amount_sek,    '45:55:N'
      define_field :amount_foreign,     '64:76:N'
      define_field :recalculation_code, '78:78:N'
      define_field :error_code,         '79:79:N'

      def initialize(raw_record)
        super
        self.type = '5'
      end
    end
  end
end
