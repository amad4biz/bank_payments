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

  it "describes the first transaciton"
  it "describes the second transaction"
  it "creates the reconsiliation correctly"


end