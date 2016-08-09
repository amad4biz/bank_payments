require 'spec_helper'

describe 'BankPayments::SwedbankExport - File' do

  subject { BankPayments::SwedbankExport::Sequence }

  let(:tax_office_account) { '50501055'                  }
  let(:tax_office_address) { 'Skatteverket 171 94 Solna' }

  let(:beneficiary_base) do
    BankPayments::Beneficiary.new do |b|
      b.name         = 'CHANGE ME'
      b.address      = 'Byvägen 12 731 00 Rala'
      b.country_code = 'FI'
      b.bank_id      = 'HELSFIHH'
      b.account      = '10278'
    end
  end

  it "sets up the two basic records" do
    seq = subject.new(tax_office_account, 'Skatteverket',tax_office_address)
    expect(seq.records.size).to eq 2
    expect(seq.records.first.name).to eq 'SKATTEVERKET'
    expect(seq.records.last.account).to eq tax_office_account
    expect(seq).to_not be_valid
  end

  context "with the bank specification example" do

    let(:beneficiary_A) do
      beneficiary_base.dup.tap { |b| b.name = 'Mottagare A' }
    end

    let(:beneficiary_B) do
      beneficiary_base.dup.tap { |b| b.name = 'Mottagare B' }
    end

    let(:beneficiary_C) do
      beneficiary_base.dup.tap { |b| b.name = 'Mottagare C' }
    end

    # See page 4 in bank_specifications/teknisk_manual_swedbank.pdf
    let(:expected_record_types) do
      [0,2,3,4,6,7,2,3,4,5,7,6,7,6,7,2,3,4,5,7,5,7,6,7,6,7,6,7,9].map(&:to_s)
    end

    let(:test_file) do
      File.join(File.expand_path('../fixtures', __FILE__), 'test_file.spisu')
    end

    def create_transaction(amount_eur, reference)
      amount_sek = 9.52 * amount_eur
      BankPayments::Transaction.new(amount_sek, amount_eur, 'EUR', reference, Date.new(2016,8,8), 101)
    end

    # Basic test data used for both record level tests as well as a file
    let!(:seq) do
      subject.new(tax_office_account, 'Skatteverket',tax_office_address).tap do |seq|

        # Mottagare A, one payment
        seq.add_transaction(beneficiary_A, create_transaction(10,'Ref 1'))

        # Mottagare B, two payments, one credit memo
        seq.add_transaction(beneficiary_B, create_transaction(10,'Ref 2'))
        seq.add_transaction(beneficiary_B, create_transaction(10,'Ref 3'))
        seq.add_transaction(beneficiary_B, create_transaction(-10,'Ref 4'))

        # Mottagare C, three payments, two credits
        seq.add_transaction(beneficiary_C, create_transaction(10,'Ref 5'))
        seq.add_transaction(beneficiary_C, create_transaction(20,'Ref 6'))
        seq.add_transaction(beneficiary_C, create_transaction(30,'Ref 7'))
        seq.add_transaction(beneficiary_C, create_transaction(-1,'Ref 8'))
        seq.add_transaction(beneficiary_C, create_transaction(-2,'Ref 9'))
      end
    end

    it "generates correct totals and record counts" do
      sequence_records = seq.records
      types            = sequence_records.map(&:type)

      # See page 4 in bank_specifications/teknisk_manual_swedbank.pdf
      expect(types).to eq expected_record_types

      expect(sequence_records.last.sum_amount_sek).to      eq '73304'
      expect(sequence_records.last.sum_amount_foreign).to  eq '7700'
      expect(sequence_records.last.total_beneficiaries).to eq '3'
      expect(sequence_records.last.total_records).to       eq '29'

      expect(seq).to be_valid
    end

    it "creates a correctly formatted file" do
      file = BankPayments::SwedbankExport::File.new('payments_file.spisu')
      file << seq << seq

      expect(file.to_file_data + "\n").to eq \
        File.read(test_file, encoding: 'iso-8859-1')
    end
  end
end
