#!/usr/bin/env ruby
# VIEW YOUR PLACED ORDERS TEST

require 'yaml'
require_relative '../lib/btce'

# LOAD KEYS
keys = YAML::load( open('keys.yml') )
api = Btce::Api.new(keys['key'], keys['secret'])

puts '============================='
api.order_list(:count => 3).each { |order|
  puts order
}
puts '============================='
puts 'At: %s' % Time.at(api.stats.server_time)
