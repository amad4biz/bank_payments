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
  # for the beneficiary.
  #
  # According to the documentation you can group money records together with the
  # beneficiary given that the have the correct serial number.
  #
  # * {BankPayments::SwedbankExport::MoneyRecord} (Payment or Credit Memo)
  # * {BankPayments::SwedbankExport::ReasonRecord}
  #
  # @author Michael Litton
  class Sequence

    # Intializes the required records for a sequence given the
    # sends account, name and adress
    def initialize(account, name, address, payment_date = nil)
      @initial_records = []

      @initial_records << OpeningRecord.new do |o_record|
        o_record.account = account
        o_record.name    = name
        o_record.address = address
      end

      @initial_records << ReconciliationRecord.new do |r_record|
        r_record.account              = account
        r_record.sum_amount_sek       = 0
        r_record.sum_amount_foreign   = 0
        r_record.total_beneficiaries  = 0
        r_record.total_records        = 2
      end

      @payment_date = payment_date

      # TODO Make this thread safe using a mutex?
      @beneficiaries = []
    end

    def records
      all_records = []
      all_records << @initial_records.first

      @beneficiaries.each_with_index do |entry,index|
        destination_records = entry[:beneficiary].to_spisu_records
        moneytary_records   = entry[:transactions].map(&:to_spisu_records)

        [destination_records + moneytary_records].flatten.each do|record|
          record.serial_number = index + 1
        end

        all_records << destination_records << moneytary_records
      end

      reconciliation                      = @initial_records.last
      reconciliation.sum_amount_sek       = sum_sek_transactions
      reconciliation.sum_amount_foreign   = sum_foreign_transactions
      reconciliation.total_beneficiaries  = @beneficiaries.size
      reconciliation.total_records        = all_records.flatten.size + 1

      all_records << reconciliation

      all_records.flatten
    end

    # Adds a transaction to an existing beneficiary or creates a
    # new one.
    def add_transaction(beneficiary, transaction)
      find_or_create_beneficiary(beneficiary) do |entry|
        entry[:transactions] << transaction
        entry[:transactions].sort_by!(&:amount_sek)
      end
    end

    # Goes through the sequence and validates that in corresponds to the
    # rules in the specification
    def valid?
      all_requried_types_present?
    end

    def to_file_data
      records.join("\n")
    end

    private

    def sum_sek_transactions
      sum_field(:amount_sek)
    end

    def sum_foreign_transactions
      sum_field(:amount_foreign)
    end

    def sum_field(field)
      tnxs = @beneficiaries.map { |e| e[:transactions] }.flatten
      tnxs.inject(0.0) { |sum,e| sum += e.send(field) }
    end

    def find_or_create_beneficiary(beneficiary, &block)
      entry = @beneficiaries.find { |entry| entry[:beneficiary] == beneficiary }

      if entry.nil?
        entry = { beneficiary:  beneficiary, transactions: [] }
        @beneficiaries << entry
      end

      yield entry
    end

    def all_requried_types_present?
      all_types = records.map do |record|
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