require 'spec_helper'

describe BankPayments::Transaction do
  it "generates the SPISU records correctly" do

    tnx = BankPayments::Transaction.new(
        amount_sek:     150_000,
        amount_foreign: 1_189_104.93,
        currency:       'JPY',
        message:        'Payment, Bill 99',
        pay_date:       Date.new(2016,8,9),
        reason:         101
    )
    record = tnx.to_spisu_records

    expect(record[0].reference_msg).to  eq 'PAYMENT, BILL 99'
    expect(record[0].amount_sek).to     eq '15000000' # Includes swedish cents
    expect(record[0].amount_foreign).to eq '118910493'
    expect(record[0].currency_code).to  eq 'JPY'
    expect(record[0].date).to           eq '160809'

    expect(record[1].code).to           eq '101'
  end

  it "skips reasons for amounts less than 150 000 kr" do
    tnx = BankPayments::Transaction.new(
        amount_sek:     149999.99,
        amount_foreign: 1_189_104.93,
        currency:       'JPY',
        message:        'Payment, Bill 99',
        pay_date:       Date.new(2016,8,9),
        reason:         101
    )

    expect(tnx.to_spisu_records.size).to eq 2
  end
end