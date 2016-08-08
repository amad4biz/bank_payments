module BankPayments

  # Encapulates all the information about the destination of a payment.
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

    def initialize
      yield self if block_given?
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
  end
end