require "bank_payments/version"
require "bank_payments/international_payment"
require "bank_payments/beneficiary"

require "bank_payments/swedbank_export/enums"
require "bank_payments/swedbank_export/record"
require "bank_payments/swedbank_export/opening_record"
require "bank_payments/swedbank_export/name_record"
require "bank_payments/swedbank_export/address_record"
require "bank_payments/swedbank_export/bank_record"
require "bank_payments/swedbank_export/money_record"
require "bank_payments/swedbank_export/credit_memo_record"
require "bank_payments/swedbank_export/payment_record"
require "bank_payments/swedbank_export/reason_record"
require "bank_payments/swedbank_export/reconciliation_record"


# Includes a simple representation of payments that can be serialized to a
# number of different banks. At the time of this writing we'll start by
# implementing the international payments for Swedbank.
#
# @author Michael Litton
module BankPayments
  # Your code goes here...
end
