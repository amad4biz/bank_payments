module BankPayments
  module SwedbankImport
    class AddressRecord < SpisuRecord

      define_field :serial_number , '2:8:N'
      define_field :payment_method, '9:9:N'
      define_field :priority,       '10:10:N'
      define_field :address,        '11:75:AN'
      define_field :country_code,   '76:77:AN'

      def initialize(raw_record)
        super
        self.type = '3'
      end
    end
  end
end
