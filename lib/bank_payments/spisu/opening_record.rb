module BankPayments::SPISU
  class OpeningRecord < Record

    define_field :account,       '2:9:N'
    define_field :creation_date, '10:15:N'
    define_field :name,          '16:37:AN'
    define_field :address,       '38:72:AN'
    define_field :pay_date,      '73:78:N'

    def initialize
      super
      self.type = '0'
      set_spisu_layout
    end

    private

    def set_spisu_layout
      set_value(79,79,'2')
    end
  end
end