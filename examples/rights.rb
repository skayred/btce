#!/usr/bin/env ruby
# PERMISSIONS CHECK TEST

require 'yaml'
require_relative '../lib/btce/api'

# LOAD KEYS
keys = YAML::load( open('keys.yml') )
api = Btce::Api.new(keys['key'], keys['secret'])

puts '============================='
puts 'Info: %s' % api.rights.info?
puts 'Trade: %s' % api.rights.trade?
puts 'Withdraw: %s' % api.rights.withdraw?
puts '============================='
puts 'At: %s' % Time.at(api.stats.server_time)
