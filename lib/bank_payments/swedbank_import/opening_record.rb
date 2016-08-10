module BankPayments
  module SwedbankImport
    class OpeningRecord < SpisuRecord

      define_field :sender,            '2:12:N'
      define_field :creation_date,     '13:18:N'
      define_field :previous_bank_day, '19:24:N'
      define_field :layout,            '25:30:AN'
      define_field :customer_id,       '31:42:AN'

      def initialize(raw_record)
        super
        self.type = '0'
      end

      def creation_date
        extract_date __callee__
      end

      def previous_bank_day
        extract_date __callee__
      end
    end
  end
end
