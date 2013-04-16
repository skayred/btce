# The BTC-E Ruby API Library

Alpha stage, but it's already beautiful:
```
$ ./btce.rb
=============================
RUR: 0.000009
USD: 0.000000
LTC: 151.872676
BTC: 0.001036
=============================
At: 2013-04-13 18:49:13 +0400
```

That was made with these lines:
```Ruby
# SIMPLE TEST
api = Btce::Api.new(KEY, SECRET)

puts "============================="
puts "RUR: %f" % api.balance.amount(Btce::RUR)
puts "USD: %f" % api.balance.amount(Btce::USD)
puts "LTC: %f" % api.balance.amount(Btce::LTC)
puts "BTC: %f" % api.balance.amount(Btce::BTC)
puts "============================="
puts "At: %s" % Time.at(api.stats.server_time)
```

Stay tuned. :heart: