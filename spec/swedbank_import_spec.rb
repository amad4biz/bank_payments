require 'spec_helper'

describe 'BankPayments::SwedbankImport - Files' do

  let(:data) do
    File.read(File.join(File.expand_path('../fixtures', __FILE__), 'confirmations.spisu'))
  end

  it "reads and understands all records" do
    file = BankPayments::SwedbankImport::File.new(data)
    expect(file.sequences.size).to eq 1
  end
end