module BankPayments::SwedbankExport

  # Defines a field in the the Swedbank SPISU format
  #
  # @author Michael Litton
  class FieldDefinition
    attr_reader :name, :start, :stop, :type

    def initialize(name, definition)
      @name                = name
      unformatted_def     = definition.split(':')
      @start, @stop, @type = unformatted_def.each_with_index.map do |value,idx|
        idx < 2 ? value.to_i : value
      end
    end

    def length
      @stop - @start + 1
    end
  end
end