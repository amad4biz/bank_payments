module BankPayments

  # Encapulates all the information about the destination of a payment.
  # We choose this class name since this is what Swedbank seems to call
  # it on their english homepage. Another viable option is also "Payee".
  #
  # @author Michael Litton
  class Beneficiary

    # Required regular fields
    attr_accessor :name, :address, :country_code

    # The BIC (Bank Identification Code) for countires within EU
    attr_accessor :bank_id

    # Can be empty for European payments
    attr_accessor :bank_name

    # IBAN
    attr_accessor :account

    # Configuration used for the address record in Swedbank SPISU
    attr_accessor :account_type, :cost_carrier, :priority

    # Creates a new Beneficiary object with defaults for part of the
    # Swedbank payments
    def initialize
      yield self if block_given?

      # Set sensible defaults
      @account_type ||= BankPayments::SwedbankExport::AccountType::CURRENCY_ACCOUNT
      @cost_carrier ||= BankPayments::SwedbankExport::CostResponsibility::OWN_EXPENSES
      @priority     ||= BankPayments::SwedbankExport::Priority::NORMAL
    end

    def eql?(other)
      instance_values == other.instance_values
    end

    def hash
      instance_values.hash
    end

    def instance_values
      Hash[instance_variables.map do |variable|
        [variable[1..-1], instance_variable_get(variable)]
      end]
    end

    def to_spisu_records
      name      = BankPayments::SwedbankExport::NameRecord.new
      name.name = @name

      address              = BankPayments::SwedbankExport::AddressRecord.new
      address.address      = @address
      address.country_code = @country_code
      address.account_type = @account_type
      address.cost_carrier = @cost_carrier
      address.priority     = @priority

      bank            = BankPayments::SwedbankExport::BankRecord.new
      bank.bank_id    = @bank_id
      bank.name       = @bank_name || ''
      bank.account    = @account

      [name, address, bank]
    end
  end
end