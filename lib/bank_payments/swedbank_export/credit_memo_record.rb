module BankPayments::SwedbankExport
  class CreditMemoRecord < AmountRecord

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
      self.type = '5'
    end

    def amount_sek=(amount)
      super change_last_digit(format_amount(amount))
    end

    def amount_foreign=(amount)
      super change_last_digit(format_amount(amount))
    end

    private

    # Set a special value in positions 44 and 78 (the last digit). This is
    # how the bank determines that this is a credit memo
    def change_last_digit(digits)
      digits[0..-2] + DIGIT_MAP[digits[-1]]
    end
  end
end


