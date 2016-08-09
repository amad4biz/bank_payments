module BankPayments::SwedbankExport

  # Contains international payments to be made to foreign beneficiaries. The file
  # contains one or more sequnces containing payments.
  #
  # @author Michael Litton
  class File
    attr_accessor :file_name

    def initialize(file_name)
      @file_name = file_name
      @sequences = []
    end

    # Adds a sequence to the file
    def <<(sequence)
      @sequences << sequence
    end

    def to_file_data
      sequence_data = @sequences.map { |sequence| sequence.to_file_data }

      sequence_data.join("\n").encode('iso-8859-1')
    end
  end
end
