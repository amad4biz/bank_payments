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
  end
end
