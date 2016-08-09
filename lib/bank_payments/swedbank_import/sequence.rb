module BankPayments
  module SwedbankImport

    # Contains all records for a sequence. Records are expected to be a text string
    # and passed to the sequence through the "<<"-method.
    #
    # @author Michael Litton
    class Sequence
      attr_reader :records

      def initialize
        @records = []
      end

      def <<(raw_record)
        new_record = case raw_record[0]
          when '0'
            OpeningRecord.new(raw_record)
          when '1'
            AccountRecord.new(raw_record)
          when '2'
            NameRecord.new(raw_record)
          when '3'
            AddressRecord.new(raw_record)
          when '5'
            MoneyRecord.new(raw_record)
          when '6'
            ReconciliationRecord.new(raw_record)
          else
            raise 'Unknown record'
        end

        @records << new_record
      end
    end
  end
end