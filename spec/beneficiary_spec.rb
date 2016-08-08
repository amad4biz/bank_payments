require 'spec_helper'
require 'set'

describe BankPayments::Beneficiary do
  it "creates an beneficiary using a block" do
    beneficiary = BankPayments::Beneficiary.new do |b|
      b.name         = 'Abo OY'
      b.address      = 'Byvägen 12 731 00 Rala'
      b.country_code = 'FI'
      b.bank_id      = 'HELSFIHH'
      b.account      = '10278'
    end

    expect(beneficiary.name).to         eq 'Abo OY'
    expect(beneficiary.address).to      eq 'Byvägen 12 731 00 Rala'
    expect(beneficiary.country_code).to eq 'FI'
    expect(beneficiary.bank_id).to      eq 'HELSFIHH'
    expect(beneficiary.account).to      eq '10278'
  end

  it "two beneficiaries with the same information must equal each other" do
    b1 = BankPayments::Beneficiary.new do |b|
      b.name         = 'Abo OY'
      b.address      = 'Byvägen 12 731 00 Rala'
      b.country_code = 'FI'
      b.bank_id      = 'HELSFIHH'
      b.account      = '10278'
    end

    b2 = BankPayments::Beneficiary.new do |b|
      b.name         = 'Abo OY'
      b.address      = 'Byvägen 12 731 00 Rala'
      b.country_code = 'FI'
      b.bank_id      = 'HELSFIHH'
      b.account      = '10278'
    end

    b3 = BankPayments::Beneficiary.new do |b|
      b.name         = 'Mike OY'
      b.address      = 'Byvägen 12 731 00 Rala'
      b.country_code = 'FI'
      b.bank_id      = 'HELSFIHH'
      b.account      = '10278'
    end

    expect(b1).to be_eql(b2)

    all_beneficiaries = Set.new
    all_beneficiaries << b1
    all_beneficiaries << b2
    all_beneficiaries << b3

    expect(all_beneficiaries.size).to eq 2

    expect([b1,b2,b3].index(b3)).to eq 2
  end
end