module BankPayments::SwedbankImport

  # Contains payments that have been made at the bank for a particular date.
  # This maps to multiple export files created ealier. It will contain up to
  # all payments requested earlier. When payouts fail the informaiton must be
  # generated elsewhere.
  #
  # @author Michael Litton
  class File
    attr_accessor :sequences

    # Given the a string of file data the sequeces and records are
    # created
    def initialize(data)
      @sequences       = []
      current_sequence = nil

      data.gsub(/(\r|\n)+/,"\n").each_line do |raw_record|
        if opening_post?(raw_record)
          current_sequence = Sequence.new
          @sequences << current_sequence
        else
          current_sequence << raw_record
        end
      end
    end

    private

    def opening_post?(raw_record)
      raw_record[0] == '0'
    end
  end
end