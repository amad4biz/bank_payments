# BankPayments

[![Coverage Status](https://coveralls.io/repos/github/apoex/bank_payments/badge.svg?branch=master)](https://coveralls.io/github/apoex/bank_payments?branch=master)
[![Build Status](https://travis-ci.org/apoex/bank_payments.svg?branch=master)](https://travis-ci.org/apoex/bank_payments)

Ruby implementation of bank payments. Starting with

* Swedbank International Payment, in SPISU-format

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bank_payments'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bank_payments

## International Payments

Note that the Swedbank file is in an older format (SPISU). In about six months the Swedish standard will be based on ISO 20022 SEPA (Single Euro Payments Area). At the time of this writing (2016-08-09) there are two alternative gems for this standard:

* [Ruby gem for creating SEPA XML files](https://github.com/salesking/sepa_king)
* [SEPA ISO20022 XML message builder](https://github.com/conanite/sepa)

When possible one should consider moving over to that standard instead.

## Usage

For anyone using a communications protocol to relay information from one party to another the important part is not the protocol itself. It's the information that needs to be sent. In order to send the information you need two pieces of information about the transaction: The beneciciary and the transactional data itself.

**Create a beneficiary**

```ruby
b = BankPayments::Beneficiary.new do |b|
  b.name         = 'Some company AO'
  b.address      = 'Byvägen 12 731 00 Rala'
  b.country_code = 'FI'
  b.bank_id      = 'HELSFIHH'
  b.account      = '10278'
end
```
**Create a transaction**

```ruby
t = BankPayments::Transaction.new(
  amount_sek:     100_000,
  amount_foreign: 1_189_104.93,
  currency:       'JPY',
  message:        'Payment, Bill 99',
  pay_date:       Date.new(2016,8,9),
  reason:         101
)
```

**Create a sequence, add payment and add it to a file**

```ruby
s = BankPayments::SwedbankExport::Sequence.new(account, name, address)
s.add_transaction(b, t)

f = BankPayments::SwedbankExport::File.new('file_name')
f << s
f.to_file_data
```

Download the result of `f.to_file_data` and upload it to the bank. The important part here is to setup the beneficiary and transactions correctly.

Use `yard` to generate the gem documentation which will give you more information about the implementation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/apoex/bank_payments.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

