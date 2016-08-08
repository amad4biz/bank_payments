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

      @records << OpeningRecord.new do |record|
        record.account = account
        record.name    = name
        record.address = address
      end

      @records << ReconciliationRecord.new do |record|
        record.account              = account
        record.sum_amount_sek       = 0
        record.sum_amount_foreign   = 0
        record.total_beneficiaries  = 0
        record.total_records        = 2
      end
    end

  end
end