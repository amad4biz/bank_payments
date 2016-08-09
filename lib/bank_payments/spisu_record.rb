require 'ostruct'
require 'unicode_utils/upcase'

module BankPayments

  # An "abstract" class that is used by records that conforms to the SPISU-format
  # for Swedbank international payments. It's a flat file format that lets
  # implementations easily describe each row similar to how the documentation is
  # structured by the bank.
  #
  # @author Michael Litton
  class SpisuRecord
    def initialize(data = ' ' * 80)
      @data   = data

      yield self if block_given?
    end

    # Used to set the attributes in child records during
    # initialization. An example definition is
    #
    # define_field :account, '2:9:N'
    #
    # which means that the account is available in position 2 to 9. The third
    # part of the definition includes the format of the field which can be
    #
    # N: Numeric, zero pad to the left of the value
    # AN: Alpha numeric, blank pad to the right of the value
    #
    # define_field :f1, '2:9:N'
    # define_field :f2, '10:12:AN'
    def self.define_field(field, definition)
      field_class = BankPayments::SwedbankExport::FieldDefinition
      (@fields ||= {})[field] = field_class.new(field, definition)
    end

    def self.defined_fields
      @fields || {}
    end

    def self.definition_for(field)
      @fields[field]
    end

    def set_text_value(start, stop, value)
      value = UnicodeUtils.upcase(value, :sv)
      set_value(start, stop, value, :ljust, ' ')
    end

    def set_numeric_value(start, stop, value)
      set_value(start, stop, value, :rjust, '0')
    end

    def set_value(start, stop, value, direction = :ljust, padstr = ' ')
      value   = serialize_value(value)
      length  = stop - start + 1
      @data[start-1,length] = value[0,length].send(direction, *[length, padstr])
    end

    def serialize_value(val)
      if val.is_a?(Date)
        val.strftime('%y%m%d')
      else
        val.to_s
      end
    end

    def type=(type)
      @data[0,1] = type.to_s
    end

    def type
      @data[0,1]
    end

    def to_s
      @data
    end

    # Attempts to handle serialization and deserialization of numeric and
    # text values in the SPISU
    def method_missing(method_name, *arguments, &block)
      record_fields   = self.class.defined_fields.keys
      requested_field = method_name.to_s.sub('=','').to_sym

      if record_fields.include?(requested_field)
        is_setter_field = method_name =~ /=/
        definition      = self.class.definition_for(requested_field)

        if is_setter_field
          args = [definition.start, definition.stop, arguments.first]
          case definition.type
            when 'N'  then set_numeric_value(*args)
            when 'AN' then set_text_value(*args)
          end
        else
          return_value = @data[definition.start-1, definition.length]
          (return_value.sub(/^0+/, "") || return_value).strip
        end
      else
        super
      end
    end

    # Ensure that we include the defined fields in the parent but still
    # allow them to be overwritten. We can't use @@fields because certain
    # fields that share their name between classes will be overwritten
    def self.inherited(base)
      base.instance_variable_set(:@fields, @fields)
    end
  end
end
