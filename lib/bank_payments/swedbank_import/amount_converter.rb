require 'bigdecimal'

module BankPayments
  module SwedbankImport

    # Used to convert Swedbanks numeric representation to a Ruby BigDecimal. It
    # especially handles the convetion that that negative numbers have the last
    # digits set as a char according to the DIGIT_MAP
    #
    # @author Michael Litton
    class AmountConverter

      DIGIT_MAP = {
        'å' => '0',
        'J' => '1',
        'K' => '2',
        'L' => '3',
        'M' => '4',
        'N' => '5',
        'O' => '6',
        'P' => '7',
        'Q' => '8',
        'R' => '9',
      }.freeze

      def self.value_to_decimal(value)
        modifier = 1

        if value[-1] =~ /\D/
          modifier = -1
          value = value[0..-2] + DIGIT_MAP[value[-1]]
        end

        BigDecimal("#{value[0..-3]}.#{value[-2..-1]}") * modifier
      end
    end
  end
end
