module BankPayments
  module SwedbankExport


    # The first record in a sequence which contains information about payer.
    #
    # @author Michael Litton
    class OpeningRecord < SpisuRecord

      define_field :account,       '2:9:N'
      define_field :creation_date, '10:15:N'
      define_field :name,          '16:37:AN'
      define_field :address,       '38:72:AN'
      define_field :pay_date,      '73:78:N'
      define_field :layout,        '79:79:N'

      def initialize
        super
        self.type = '0'
        set_spisu_layout
      end

      private

      def set_spisu_layout
        self.layout  = '2'
      end
    end
  end
end