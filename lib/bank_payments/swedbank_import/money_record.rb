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

      def corrected_by_bank?
        error_code == '1'
      end

      def amount_sek
        AmountConverter.value_to_decimal(extract_raw_value __callee__)
      end

      def bank_amount_sek
        AmountConverter.value_to_decimal(extract_raw_value __callee__)
      end

      def amount_foreign
        AmountConverter.value_to_decimal(extract_raw_value __callee__)
      end

      # Enum with
      # '0' => The bank has calculated it's value from the foreign amount'
      # '9' => The bank has calculated it's value form the SEK amount
      def recalculation_code
        extract_raw_value __callee__
      end

      # Enum with
      # '0' = OK
      # '1' = Payment corrected by the bank
      def error_code
        extract_raw_value __callee__
      end
    end
  end
end
