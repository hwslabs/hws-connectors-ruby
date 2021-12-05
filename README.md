# Hws::Connectors

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/hws/connectors`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hws-connectors'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hws-connectors

## Usage

### Connector Configuration

```ruby
Hws::Connectors.configure do |config|
  config.logger = Rails.logger
  config.options = { skip_logging: %w(get) }
end
```

### Hypto::Payout

```ruby
CLIENT_INFO = { 'api_token' => "<HYPTO_API_TOKEN>", 'env' => 'development | production' }
$hypto_payout_client = Hws::Connectors::Hypto::Payout.new(CLIENT_INFO)

beneficiary = Hws::Connectors::Dto::Beneficiary.new(name: 'Logesh', account_number: '12345678', account_ifsc: 'HDFC0005322', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'IMPS', amount: 1)
resp = $hypto_payout_client.send_to_bank_account(request: request)

beneficiary = Hws::Connectors::Dto::Beneficiary.new(name: 'Logesh', upi_id: 'ddlogesh@okhdfcbank', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'UPI', amount: 1)
resp = $hypto_payout_client.send_to_upi_id(request: request)

resp = $hypto_payout_client.status(reference_number: 'reference_number')
```

### Hypto::VirtualAccount

```ruby
$hypto_va_client = Hws::Connectors::Hypto::VirtualAccount.new(CLIENT_INFO)

request = Hws::Connectors::Dto::VirtualAccountRequest.new(reference_number: 'REF123', meta: { settle_to: 'SELF', parent_type: 'PARTNER' })
resp = $hypto_va_client.create(request: request)

request = Hws::Connectors::Dto::VirtualAccountRequest.new(reference_number: 'REF139856', meta: { id: 139856 })
resp = $hypto_va_client.update(request: request)

resp = $hypto_va_client.activate(reference_number: 139856)

resp = $hypto_va_client.deactivate(reference_number: 139856)

resp = $hypto_va_client.fetch(reference_number: 139856)
```

#### Payout

```ruby
beneficiary = Hws::Connectors::Dto::Beneficiary.new(name: 'Logesh', account_number: '12345678', account_ifsc: 'HDFC0005322', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'IMPS', amount: 1, meta: { va_id: 139856 })
resp = $hypto_va_client.send_to_bank_account(request: request)

beneficiary = Hws::Connectors::Dto::Beneficiary.new(name: 'Logesh', upi_id: 'ddlogesh@okhdfcbank', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'UPI', amount: 1, meta: { va_id: 139856 })
resp = $hypto_va_client.send_to_upi_id(request: request)

resp = $hypto_va_client.status(reference_number: 'reference_number', va_id: 139856)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hws-connectors. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hws::Connectors project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hws-connectors/blob/master/CODE_OF_CONDUCT.md).
