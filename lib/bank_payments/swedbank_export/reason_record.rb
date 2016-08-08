module BankPayments::SwedbankExport
  class ReasonRecord < Record

    define_field :serial_number,  '2:8:N'
    define_field :code,           '9:11:N'

    def initialize
      super
      self.type = '7'
    end
  end
end


