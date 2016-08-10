require 'spec_helper'

describe 'BankPayments::SwedbankImport - Files' do

  let(:data) do
    File.read(File.join(File.expand_path('../fixtures', __FILE__), 'confirmations.spisu'))
  end

  let(:test_file) do
    BankPayments::SwedbankImport::File.new(data)
  end

  let(:records) do
    test_file.sequences.map(&:records).flatten
  end

  it "creates the right number of sequences and records" do
    expect(test_file.sequences.size).to eq 1
    expect(records.size).to eq 9
  end

  it "creates the opening record correctly" do
    opening_record = records[0]

    expect(opening_record.sender).to            eq '15769383'
    expect(opening_record.creation_date).to     eq Date.new(2009, 12, 17)
    expect(opening_record.previous_bank_day).to eq Date.new(2009, 12, 16)
    expect(opening_record.layout).to            eq 'SESISU'
    expect(opening_record.customer_id).to       eq 'SHIPPING HB'
  end

  it "creates the account record correctly" do
    account_record = records[1]

    expect(account_record.debit_account).to    eq '9749749744'
    expect(account_record.transaction_date).to eq Date.new(2009,12,17)
  end

  it "describes the first transaciton" do
    name_record, address_record, money_record = records[2..4]

    expect(name_record.serial_number).to       eq '102'
    expect(name_record.name).to                eq 'ABO OY'
    expect(name_record.currency_code).to       eq 'EUR'
    expect(name_record.merges_payments).to     eq '0'

    expect(address_record.transaction_id).to   eq '2170079'
    expect(address_record.payment_method).to   eq '1'
    expect(address_record.priority).to         eq '0'
    expect(address_record).to_not              be_express
    expect(address_record.address).to          eq 'BYVAGEN 12                    731 00 RALA FINLAND'
    expect(address_record.country_code).to     eq 'FI'

    expect(money_record.serial_number).to      eq '102'
    expect(money_record.reference).to          eq '1224'
    expect(money_record.amount_sek).to         eq -1800
    expect(money_record.bank_amount_sek).to    eq 1890
    expect(money_record.amount_foreign).to     eq -173.33
    expect(money_record.recalculation_code).to eq '0'
    expect(money_record).to_not                be_corrected_by_bank
  end

  it "describes the second transaction" do
    name_record, address_record, money_record = records[5..7]

    expect(name_record.serial_number).to       eq '102'
    expect(name_record.name).to                eq 'ABO OY'
    expect(name_record.currency_code).to       eq 'EUR'
    expect(name_record.merges_payments).to     eq '0'

    expect(address_record.transaction_id).to   eq '2170079'
    expect(address_record.payment_method).to   eq '1'
    expect(address_record.priority).to         eq '0'
    expect(address_record).to_not              be_express
    expect(address_record.address).to          eq 'BYVAGEN 12                    731 00 RALA FINLAND'
    expect(address_record.country_code).to     eq 'FI'

    expect(money_record.serial_number).to      eq '102'
    expect(money_record.reference).to          eq '1225'
    expect(money_record.amount_sek).to         eq 40204.26
    expect(money_record.bank_amount_sek).to    eq 46996.48
    expect(money_record.amount_foreign).to     eq 4310.00
    expect(money_record.recalculation_code).to eq '0'
    expect(money_record).to_not                be_corrected_by_bank
  end

  it "creates the reconciliation correctly" do
    reconciliation_record = records[8]

    expect(reconciliation_record.sum_amount_sek).to      eq 38404.26
    expect(reconciliation_record.sum_bank_amount_sek).to eq 45106.48
    expect(reconciliation_record.sum_amount_foreign).to  eq 4136.67
    expect(reconciliation_record.transaction_cost).to    eq 0.0
    expect(reconciliation_record.total_beneficiaries).to eq '1'
    expect(reconciliation_record.total_records).to       eq '9'

  end


end