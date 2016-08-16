module BankPayments

  # Represents a monetary transaction
  class Transaction
    attr_reader :amount_sek, :amount_foreign, :currency, :message, :pay_date, :reason

    def initialize(amount_sek:, amount_foreign:, currency:, message:, pay_date:, reason:)
      @amount_sek       = amount_sek
      @amount_foreign   = amount_foreign
      @currency         = currency
      @message          = message
      @pay_date         = pay_date
      @reason           = reason
    end

    def to_spisu_records
      money_record = if amount_sek >= 0
        BankPayments::SwedbankExport::PaymentRecord.new
      else
        BankPayments::SwedbankExport::CreditMemoRecord.new
      end

      money_record.reference_msg   = @message
      money_record.amount_sek      = @amount_sek
      money_record.amount_foreign  = @amount_foreign
      money_record.currency_code   = @currency
      money_record.date            = @pay_date

      if amount_sek.abs >= 150_000
        reason_record = BankPayments::SwedbankExport::ReasonRecord.new
        reason_record.code = @reason
        [money_record, reason_record]
      else
        [money_record]
      end
    end
  end
end