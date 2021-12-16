<h1 align="center">
  Hws Connectors
</h1>

<p align="center">
  <a href="LICENSE.txt"><img alt="License" src="https://img.shields.io/github/license/hwslabs/hws-connectors-ruby"></a>
  <a href="https://rubygems.org/gems/hws-connectors"><img alt="Ruby gem" src="http://img.shields.io/gem/v/hws-connectors.svg"></a>
  <a href="https://github.com/hwslabs/hws-connectors-ruby/pulls"><img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square"></a>
</p>

An Open Source Connector to integrate with any financial service providers like banks, fintechs, etc., providing a unified response across various providers.

**NOTE**: _We are starting of with Hypto connectors & will be introducing the integrations of other financial service providers shortly._

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'hws-connectors'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install hws-connectors
```

### Configuration

```ruby
Hws::Connectors.configure do |config|
  config.logger = Rails.logger
  config.options = { skip_logging: %w(get) },
    config.webhooks = {
      'payouts' => {
        'callback' => -> (entity, response) { puts "#{entity.inspect} - #{response.inspect}" },
      },
      'virtual_accounts' => {
        'notify' => -> (entity, response) { puts "#{entity.inspect} - #{response.inspect}" }
      }
    }
end
```

### Payout

```ruby
# Initialise payout client (eg: Hypto)
CLIENT_INFO = { 'api_token' => "<HYPTO_API_TOKEN>", 'env' => 'development | production' }
$hypto_payout_client = Hws::Connectors::Hypto::Payout.new(CLIENT_INFO)

# Send to bank account
beneficiary = Hws::Connectors::Dto::AccountDetail.new(name: 'Logesh', account_number: '12345678', account_ifsc: 'HDFC0005322', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'IMPS', amount: 1)
resp = $hypto_payout_client.send_to_bank_account(request: request)

# Send to Upi Id
beneficiary = Hws::Connectors::Dto::AccountDetail.new(name: 'Logesh', upi_id: 'ddlogesh@okhdfcbank', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'UPI', amount: 1)
resp = $hypto_payout_client.send_to_upi_id(request: request)

# Fetch payout status
resp = $hypto_payout_client.status(reference_number: 'reference_number')
```

### VirtualAccount

```ruby
# Initialise virtual account client (eg: Hypto)
$hypto_va_client = Hws::Connectors::Hypto::VirtualAccount.new(CLIENT_INFO)

# Create a virtual account
request = Hws::Connectors::Dto::VirtualAccountRequest.new(reference_number: 'REF123')
resp = $hypto_va_client.create(request: request)

# Update an existing virtual account
request = Hws::Connectors::Dto::VirtualAccountRequest.new(reference_number: 'REF139856', meta: { id: 139856 })
resp = $hypto_va_client.update(request: request)

# Activate a virtual account
resp = $hypto_va_client.activate(reference_number: 139856)

# Deactivate a virtual account
resp = $hypto_va_client.deactivate(reference_number: 139856)

# Fetch a virtual account
resp = $hypto_va_client.fetch(reference_number: 139856)
```

#### Payout (From Virtual Account)

```ruby
# Send to bank account
beneficiary = Hws::Connectors::Dto::AccountDetail.new(name: 'Logesh', account_number: '12345678', account_ifsc: 'HDFC0005322', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'IMPS', amount: 1, meta: { va_id: 139856 })
resp = $hypto_va_client.send_to_bank_account(request: request)

# Send to Upi Id
beneficiary = Hws::Connectors::Dto::AccountDetail.new(name: 'Logesh', upi_id: 'ddlogesh@okhdfcbank', note: 'Connector testing')
request = Hws::Connectors::Dto::PayoutRequest.new(beneficiary: beneficiary, payment_type: 'UPI', amount: 1, meta: { va_id: 139856 })
resp = $hypto_va_client.send_to_upi_id(request: request)

# Fetch payout status
resp = $hypto_va_client.status(reference_number: 'reference_number', va_id: 139856)
```

### Webhooks

```
Payout Status 
POST : {{host}}/hws/connectors/payouts/hypto/callback

Credit Virtual Account
POST : {{host}}/hws/connectors/virtual_accounts/hypto/notify
```

### Contributing

We wish the **Fintech** community to come forward & contribute to this project for a good social cause, by sending us a pull request: may be a minor bug fix, bank integration, financial connectors or major improvements.

**Every contribution is welcome!**
