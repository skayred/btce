## The BTC-E Ruby API Library :ru:
[![Gem Version](https://badge.fury.io/rb/btce-api.png)](http://badge.fury.io/rb/btce-api)

### Installation
```
gem install btce-api
```

### Usage
```
$ ./balance.rb
=============================
RUR: 2001.000004
USD: 0.000061
LTC: 32.242009
BTC: 0.000141
=============================
At: 2013-04-21 16:34:50 +0400
```
That was made with these lines:
```Ruby
require 'btce'
api = Btce::Api.new(KEY, SECRET)

puts '============================='
puts 'RUR: %f' % api.balance.amount(Btce::RUR)
puts 'USD: %f' % api.balance.amount(Btce::USD)
puts 'LTC: %f' % api.balance.amount(Btce::LTC)
puts 'BTC: %f' % api.balance.amount(Btce::BTC)
puts '============================='
puts 'At: %s' % Time.at(api.stats.server_time)
```
Check other examples in the **examples/** folder,
this library has the **100%** private API coverage.

### FYI
* Public API is coming soon;
* API methods will throw an exception if server reports an error, please catch that;
* Don't forget to update keys with your own, otherwise examples won't work;
* Please feel free to report/fix any bugs;
* Check out the **LICENSE**.

### Documentation
API is synced wih https://btc-e.com/api/documentation

* **GetInfo - Api::get_info**, also there are helpers:
  - (unofficial) `Api::update`, drops info cache (next 3 methods are cached);
  - (unofficial) `Api::balance`, returns a `Types::Balance` hash;
  - (unofficial) `Api::rights`, returns a `Types::Rights` hash;
  - (unofficial) `Api::stats`, returns a `Types::Stats` hash.
* **TransHistory - Api::trans_history**
  - options: `from, count, from_id, end_id, order, since, end`
  - returns a `Types::Transaction` set.
* **TradeHistory - Api::trade_history**
  - options: `from, count, from_id, end_id, order, since, end, pair`
  - returns a `Types::Trade` set.
* **OrderList - Api::order_list**
  - options: `from, count, from_id, end_id, order, since, end, pair, active`
  - returns a `Types::Order` set.
* **Trade - Api::trade**
  - parameters: `pair, type, rate, amount`
  - returns a `Types::PlacedOrder` object.
* **CancelOrder - Api::cancel_order**
  - parameter: `order_id`
  - returns `order_id` of the cancelled order.
* **Types::Response**
  - models response from server, used in `Btce::Bus`
* **Types::Balance**
  - `amount(currency)`, where currency is like `Btce::USD`
* **Types::Rights**
  - `info?`
  - `trade?`
  - `withdraw?`
* **Types::Stats**
  - `transaction_count`, returns your overall transaction count;
  - `open_orders`, returns your overall open orders count;
  - `server_time` - subj.
* **Types::Transaction**
  - has methods `id, type, amount, currency, desc, status, timestamp`
* **Types::Trade**
  - has methods `id, pair, type, amount, rate, order_id, is_your_order, timestamp`
* **Types::Order**
  - has methods `id, pair, type, amount, rate, timestamp_created, status`
  - + one bonus `active?` which returns `true` if order is active.
* **Types::PlacedOrder**
  - has methods `received, remains, order_id`
  - + one bonus `cancel` which cancels the order itself.

### Donate
 * Bitcoin: 1KRagCPzzLYvNVzZSXUZN4f2hCRZibtiXa
 * Litecoin: LLN2L8fsATuxNtQdiKeyK8ceqNuAVNexFf

![We love bitcoin](https://en.bitcoin.it/w/images/en/b/b2/WeLv_BC_48px.png)