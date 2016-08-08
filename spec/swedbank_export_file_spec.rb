require 'spec_helper'

describe 'BankPayments::SwedbankExport - File' do

  subject { BankPayments::SwedbankExport::Sequence }

  let(:tax_office_account) { '50501055'                  }
  let(:tax_office_address) { 'Skatteverket 171 94 Solna' }

  it "sets up the two basic records" do
    seq = subject.new(tax_office_account, 'Skatteverket',tax_office_address)
    expect(seq.records.size).to eq 2
    expect(seq.records.first.name).to eq 'SKATTEVERKET'
    expect(seq.records.last.account).to eq tax_office_account
    expect(seq).to_not be_valid
  end

  context "with the bank specification example" do

    let(:beneficiary_base) do
      BankPayments::Beneficiary.new do |b|
        b.name         = 'CHANGE ME'
        b.address      = 'Byvägen 12 731 00 Rala'
        b.country_code = 'FI'
        b.bank_id      = 'HELSFIHH'
        b.account      = '10278'
      end
    end

    let(:beneficiary_A) do
      beneficiary_base.dup.tap do |b|
        b.name = 'Mottagare A'
      end
    end

    let(:beneficiary_B) do
      beneficiary_base.dup.tap do |b|
        b.name = 'Mottagare B'
      end
    end

    let(:beneficiary_C) do
      beneficiary_base.dup.tap do |b|
        b.name = 'Mottagare C'
      end
    end

    # See page 4 in bank_specifications/teknisk_manual_swedbank.pdf
    let(:expected_record_types) do
      [0,2,3,4,6,7,2,3,4,5,7,6,7,6,7,2,3,4,5,7,5,7,6,7,6,7,6,7,9].map(&:to_s)
    end

    def create_transaction(amount_eur)
      amount_sek = 9.52 * amount_eur
      BankPayments::Transaction.new(amount_sek, amount_eur, 'EUR', 'Ref #{rand(1000)}', Date.new(2016,8,8), 101)
    end

    it "generates correct totals and record counts" do
      seq = subject.new(tax_office_account, 'Skatteverket',tax_office_address)

      # Mottagare A, one payment
      seq.add_transaction(beneficiary_A, create_transaction(10))

      # Mottagare B, two payments, one credit memo
      seq.add_transaction(beneficiary_B, create_transaction(10))
      seq.add_transaction(beneficiary_B, create_transaction(10))
      seq.add_transaction(beneficiary_B, create_transaction(-10))

      # Mottagare C, three payments, two credits
      seq.add_transaction(beneficiary_C, create_transaction(10))
      seq.add_transaction(beneficiary_C, create_transaction(20))
      seq.add_transaction(beneficiary_C, create_transaction(30))
      seq.add_transaction(beneficiary_C, create_transaction(-1))
      seq.add_transaction(beneficiary_C, create_transaction(-2))

      sequence_records = seq.records
      types            = sequence_records.map(&:type)

      # See page 4 in bank_specifications/teknisk_manual_swedbank.pdf
      expect(types).to eq expected_record_types

      expect(sequence_records.last.sum_amount_sek).to      eq '73304'
      expect(sequence_records.last.sum_amount_foreign).to  eq '7700'
      expect(sequence_records.last.total_beneficiaries).to eq '3'
      expect(sequence_records.last.total_records).to       eq '29'
    end
  end
end
