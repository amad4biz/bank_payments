require 'spec_helper'

describe BankPayments::Transaction do
  it "generates the SPISU records correctly" do
    tnx = BankPayments::Transaction.new(100_000, 1_189_104.93, 'JPY', 'Invoice 1', Date.new(2016,8,8), 101)
    record = tnx.to_spisu_records

    expect(record[0].reference_msg).to  eq 'INVOICE 1'
    expect(record[0].amount_sek).to     eq '10000000' # Includes swedish cents
    expect(record[0].amount_foreign).to eq '118910493'
    expect(record[0].currency_code).to  eq 'JPY'
    expect(record[0].date).to           eq '160808'

    expect(record[1].code).to           eq '101'
  end
end