module BankPayments
  module SwedbankImport
    class ReconciliationRecord < SpisuRecord

      define_field :sum_amount_sek,      '2:13:N'
      define_field :sum_bank_amount_sek, '14:25:N'
      define_field :sum_amount_foreign,  '26:40:N'
      define_field :transaction_cost,    '41:52:N'
      define_field :total_beneficiaries, '53:64:N'
      define_field :total_records,       '65:76:N'

      def initialize(raw_record)
        super
        self.type = '6'
      end
    end
  end
end
