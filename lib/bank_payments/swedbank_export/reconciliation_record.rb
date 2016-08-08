module BankPayments::SwedbankExport
  class ReconciliationRecord < Record

    define_field :account,             '2:9:N'
    define_field :sum_amount_sek,      '10:21:N'
    define_field :sum_amount_foreign,  '64:78:N'
    define_field :total_beneficiaries, '32:43:N'
    define_field :total_records,       '44:55:N'

    DIGIT_MAP = {
      '0' => '-',
      '1' => 'J',
      '2' => 'K',
      '3' => 'L',
      '4' => 'M',
      '5' => 'N',
      '6' => 'O',
      '7' => 'P',
      '8' => 'Q',
      '9' => 'R'
    }.freeze

    def initialize
      super
      self.type = '9'
    end

    def sum_amount_sek=(amount)
      super reformat_sums(amount)
    end

    def sum_amount_foreign=(amount)
      super reformat_sums(amount)
    end

    private

    def reformat_sums(amount)
      if amount >= 0
        amount.spisu_format
      else
        change_last_digit(amount.abs.spisu_format)
      end
    end

    # Set a special value in positions 44 and 78 (the last digit). This is
    # how the bank determines that this is a credit memo
    def change_last_digit(digits)
      digits[0..-2] + DIGIT_MAP[digits[-1]]
    end
  end
end
