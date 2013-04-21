#!/usr/bin/env ruby
# VIEW YOUR LAST 3 TRANSACTIONS TEST

require 'yaml'
require_relative '../lib/api'

# LOAD KEYS
keys = YAML::load( open('keys.yml') )
api = Btce::Api.new(keys['key'], keys['secret'])

puts '============================='
api.trans_history(:count => 3).each { |transaction|
  puts transaction
}
puts '============================='
puts 'At: %s' % Time.at(api.stats.server_time)
