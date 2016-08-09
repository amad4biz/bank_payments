require 'core_extensions/numeric/spisu'
Numeric.include CoreExtensions::Numeric::SPISU

require "bank_payments/version"
require "bank_payments/international_payment"
require "bank_payments/beneficiary"
require "bank_payments/transaction"
require "bank_payments/spisu_record"

require "bank_payments/swedbank_export/enums"
require "bank_payments/swedbank_export/field_definition"
require "bank_payments/swedbank_export/opening_record"
require "bank_payments/swedbank_export/name_record"
require "bank_payments/swedbank_export/address_record"
require "bank_payments/swedbank_export/bank_record"
require "bank_payments/swedbank_export/money_record"
require "bank_payments/swedbank_export/credit_memo_record"
require "bank_payments/swedbank_export/payment_record"
require "bank_payments/swedbank_export/reason_record"
require "bank_payments/swedbank_export/reconciliation_record"

require "bank_payments/swedbank_export/sequence"
require "bank_payments/swedbank_export/file"

require "bank_payments/swedbank_import/sequence"
require "bank_payments/swedbank_import/file"

require "bank_payments/swedbank_import/account_record"
require "bank_payments/swedbank_import/address_record"
require "bank_payments/swedbank_import/money_record"
require "bank_payments/swedbank_import/name_record"
require "bank_payments/swedbank_import/opening_record"
require "bank_payments/swedbank_import/reconciliation_record"

# Includes a simple representation of payments that can be serialized to a
# number of different banks. At the time of this writing we'll start by
# implementing the international payments for Swedbank.
#
# @author Michael Litton
module BankPayments
  # Your code goes here...
end
