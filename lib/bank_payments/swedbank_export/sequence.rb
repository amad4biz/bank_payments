module BankPayments::SwedbankExport

  # An export file may contain multiple sequences. A sequence starts with an
  # {BankPayments::SwedbankExport::OpeningRecord} and ends with an
  # {BankPayments::SwedbankExport::ReconciliationRecord}. Each sequence will
  # consist of at least the following:
  #
  # * {BankPayments::SwedbankExport::OpeningRecord}
  # * {BankPayments::SwedbankExport::NameRecord}
  # * {BankPayments::SwedbankExport::AddressRecord}
  # * {BankPayments::SwedbankExport::BankRecord}
  # * {BankPayments::SwedbankExport::MoneyRecord} (Payment or Credit Memo)
  # * {BankPayments::SwedbankExport::ReasonRecord}
  # * {BankPayments::SwedbankExport::ReconciliationRecord}
  #
  # In particular you need to supply the following per beneficiary/payee:
  #
  # * {BankPayments::SwedbankExport::NameRecord}
  # * {BankPayments::SwedbankExport::AddressRecord}
  # * {BankPayments::SwedbankExport::BankRecord}
  #
  # which describes where the payment should be made. Then you will supply
  # a money record (payment or credit memo) together with it reason to to
  # describe a payment. All of these records will have a unique serial number
  # for the beneciciary.
  #
  # According to the documentation you can group money records together with the
  # beneficiary given that the have the correct serial number.
  #
  # * {BankPayments::SwedbankExport::MoneyRecord} (Payment or Credit Memo)
  # * {BankPayments::SwedbankExport::ReasonRecord}
  #
  # @author Michael Litton
  class Sequence
    attr_reader :records

    # Intializes the required records for a sequence given the
    # sends account, name and adress
    def initialize(account, name, address, payment_date = nil)
      @records = []

      @records << OpeningRecord.new do |o_record|
        o_record.account = account
        o_record.name    = name
        o_record.address = address
      end

      @records << ReconciliationRecord.new do |r_record|
        r_record.account              = account
        r_record.sum_amount_sek       = 0
        r_record.sum_amount_foreign   = 0
        r_record.total_beneficiaries  = 0
        r_record.total_records        = 2
      end

      # TODO Make this thread safe using a mutex?
      @beneficiary_counter = 0
    end

    # Adds a transaction to an existing beneficiary or creates a
    # new one.
    def add_transaction(beneficiary, transaction)

    end

    # Goes through the sequence and validates that in corresponds to the
    # rules in the specification
    def valid?
      all_requried_types_present?
    end

    private

    def all_requried_types_present?
      all_types = @records.map do |record|
        if record.is_a?(MoneyRecord)
          'MoneyRecord'
        else
          record.class.name.split('::').last
        end
      end

      required_types = %w(OpeningRecord NameRecord AddressRecord BankRecord
        MoneyRecord ReasonRecord ReconciliationRecord)

      (required_types - all_types.uniq).size == 0
    end

  end
end