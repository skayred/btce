#!/usr/bin/env ruby
# PLACE 1 LTC SELL ORDER, VIEW STATUS, CANCEL, VIEW STATUS

require 'yaml'
require 'test/unit/assertions'
require_relative '../lib/btce/api'

# LOAD KEYS
keys = YAML::load( open('keys.yml') )
api = Btce::Api.new(keys['key'], keys['secret'])

puts '============================='
placed = api.trade(Btce::LTC_RUR, Btce::SELL, 120, 1) # sell 1 LTC for 120 RUR
puts 'Placed: %s' % placed
puts api.order_list(:count => 1).pop # last order
puts api.trans_history(:count => 1).pop # last transaction
puts 'Sleeping for 10 secs, check website for orders or just run ./orders.rb'

sleep 10

puts 'Cancelled order %s' % api.cancel_order(placed.order_id)
puts api.trans_history(:count => 1).pop # last transaction
puts 'Please check website anyway'
puts '============================='
puts 'At: %s' % Time.at(api.stats.server_time)
