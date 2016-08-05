require 'spec_helper'

describe BankPayments::SPISU do

  context "with an abstract record" do
    subject { BankPayments::SPISU::Record }

    it "has correct length" do
      expect(subject.new.to_s.size).to eq 80
    end

    it "sets a record id" do
      record = subject.new
      record.type = 1
      expect(record.type).to eq '1'
    end

    it "can pad with zeroes" do
      record = subject.new
      record.set_numeric_value(10,20,120)
      expect(record.to_s).to eq \
        "         00000000120                                                            "
    end

    it "can pad with blanks" do
      record = subject.new
      record.set_numeric_value(1,80,'')
      record.set_text_value(3,10,'data')
      expect(record.to_s).to eq \
        "00DATA    0000000000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  context "with a opening record" do
    subject { BankPayments::SPISU::OpeningRecord }

    it "sets type to zero" do
      record = subject.new
      expect(record.type).to eq '0'
    end

    it "sets bankgiro correctly" do
      record = subject.new
      record.account = '6381040'
      expect(record.to_s).to match /6381040/
      expect(record.account).to eq '6381040'
    end

    it "sets the file date with the right format"  do
      record = subject.new
      record.creation_date = Date.new(2016,8,5)
      expect(record.to_s).to match /160805/
      expect(record.creation_date).to eq '160805'
      expect(record.creation_date.size).to eq 6
    end

    it "can contain an optional long name" do
      record = subject.new
      record.name = 'Globally Fantastic Machinery Inc.'
      expect(record.name).to eq 'GLOBALLY FANTASTIC MAC'
      expect(record.name.size).to eq 22
      expect(record.to_s).to match /GLOBALLY FANTASTIC/
      expect(record.to_s[15,22]).to eq 'GLOBALLY FANTASTIC MAC'
    end

    it "can contain an optional send address" do
      record = subject.new
      record.address = 'Virkesvägen 12'
      expect(record.address).to eq 'VIRKESVÄGEN 12'
    end

    # This requires that all payment records (type = 6) are zeroed out.
    # TODO Create a nice implementation of this rule with associated
    # validations
    it "can set an explicit payment date" do
      record = subject.new
      record.pay_date = Date.new(2016,8,5)
      expect(record.to_s).to match /160805/
      expect(record.to_s[72,6]).to eq '160805'
      expect(record.pay_date).to eq '160805'
      expect(record.pay_date.size).to eq 6
    end
  end
end