module BankPayments::SwedbankImport

  # Contains all records for a sequence. Records are expected to be a text string
  # and passed to the sequence through the "<<"-method.
  #
  # @author Michael Litton
  class Sequence
    attr_reader :records

    def initalize
      @records = []
    end

    def <<(raw_record)

    end

  end
end