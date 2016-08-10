module BankPayments
  module SwedbankImport
    class AddressRecord < SpisuRecord

      define_field :transaction_id, '2:8:N'
      define_field :payment_method, '9:9:N'
      define_field :priority,       '10:10:N'
      define_field :address,        '11:75:AN'
      define_field :country_code,   '76:77:AN'

      def initialize(raw_record)
        super
        self.type = '3'
      end

      def express?
        priority == '1'
      end

      # Enum where
      # '0' => 'Paid by check'
      # '1' => 'Paid by depositing into an account'
      def payment_method
        extract_raw_value __callee__
      end

      # Enum where
      # '0' => 'Normal priority'
      # '1' => 'Express priority'
      def priority
        extract_raw_value __callee__
      end
    end
  end
end
