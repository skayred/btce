#!/usr/bin/env ruby
# VIEW BALANCE TEST

require 'yaml'
require_relative '../lib/api'

# LOAD KEYS
keys = YAML::load( open('keys.yml') )
api = Btce::Api.new(keys['key'], keys['secret'])

puts '============================='
puts 'RUR: %f' % api.balance.amount(Btce::RUR)
puts 'USD: %f' % api.balance.amount(Btce::USD)
puts 'LTC: %f' % api.balance.amount(Btce::LTC)
puts 'BTC: %f' % api.balance.amount(Btce::BTC)
puts '============================='
puts 'At: %s' % Time.at(api.stats.server_time)
