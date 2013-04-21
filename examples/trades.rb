#!/usr/bin/env ruby
# VIEW YOUR LAST 3 TRADES TEST

require 'yaml'
require_relative '../lib/btce/api'

# LOAD KEYS
keys = YAML::load( open('keys.yml') )
api = Btce::Api.new(keys['key'], keys['secret'])

puts '============================='
api.trade_history(:count => 3).each { |trade|
  puts trade
}
puts '============================='
puts 'At: %s' % Time.at(api.stats.server_time)
