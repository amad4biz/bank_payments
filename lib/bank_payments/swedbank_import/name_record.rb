module BankPayments
  module SwedbankImport
    class NameRecord < SpisuRecord

      define_field :serial_number,   '2:8:N'
      define_field :name,            '9:73:AN'
      define_field :currency_code,   '74:76'
      define_field :merges_payments, '77:77:N'

      def initialize(raw_record)
        super
        self.type = '2'
      end
    end
  end
end
