#!/usr/bin/env ruby

# The BTC-E Ruby API Library
# Copyright (C) 2013 Maxim Kouprianov
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#  claim that you wrote the original software. If you use this software
#  in a product, an acknowledgment in the product documentation would be
#  appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#  misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
#
# Authors: Maxim Kouprianov <maxim@kouprianov.com>
#

require 'openssl'
require 'net/https'
require 'json'
require 'cgi'

KEY = '1M90AU8O-HA03QOUY-F8M9EVSO-FAO2DEM3-PID3F4YD'
SECRET = '1e43203818fa15958ef51a73af55fa603a203b2530ccd712f9200d3fd4f3f66c'

HOST = 'btc-e.com'
PORT = '443'
AGENT = 'Mozilla/4.0 (compatible; BTC-E Ruby API library; Xlab)'
API_URL = '/tapi'
HMAC_SHA = 'sha512'

module Btce

  # Currencies, specific for BTC-E
  RUR = "rur"
  USD = "usd"
  LTC = "ltc"
  BTC = "btc"

  class Bus
    def initialize api_key, api_secret
      @api_key = api_key
      @api_secret = api_secret
    end

    def request data
      # Timestamp for the request
      data[:nonce] = Time::now.to_i - 1

      # Form parametrized string
      postdata = data.collect do |key, value|
        "#{key}=#{CGI::escape(value.to_s)}"
      end.join('&')

      # Open HTTPS connection
      Net::HTTP.start(HOST, PORT, :use_ssl => true) do |http|
        # Headers setup
        headers = {
          'Sign' => sign(postdata),
          'Key' => @api_key,
          'User-Agent' => AGENT
        }

        # Send signed data
        return http.post(API_URL, postdata, headers).body
      end
    end

    def sign data
      # Sign data with the HMAC SHA-512 algorhythm
      # Read https://btc-e.com/api/documentation
      OpenSSL::HMAC.hexdigest(HMAC_SHA, @api_secret, data)
    end
  end

  class Api
    attr_reader :last_error

    def initialize api_key, api_secret
      @bus = Btce::Bus.new(api_key, api_secret)
    end

    # getInfo
    def get_info
      response = Types::Response.new(JSON.parse(@bus.request({"method" => "getInfo"})))
      raise "server responded: #{response.error}" if response.success.zero?
      return response
    end

    # UNOFFICIAL: updates `getInfo` cache
    def update
      @info = get_info()
    end

    # UNOFFICIAL: getInfo -> funds
    def balance
      update() unless @info
      Types::Balance.new @info.return
    end

    # UNOFFICIAL: getInfo -> rights
    def rights
      update() unless @info
      Types::Rights.new @info.return
    end

    # UNOFFICIAL: getInfo -> other
    def stats
      update() unless @info
      Types::Stats.new @info.return
    end

    # TransHistory
    # Options are: from, count, from_id, end_id, order, since, end
    def trans_history options = {
        :from => 0,
        :count => 1000,
        :from_id => 0,
        :end_id => nil,
        :order => :DESC, # ASC
        :since => 0,
        :end => nil
      }

      options[:method] = "TransHistory"
      response = Types::Response.new(JSON.parse(@bus.request(options)))
      raise "server responded: #{response.error}" if response.success.zero?
      return response
    end

    # TradeHistory
    # Options are: from, count, from_id, end_id, order, since, end, pair
    def trade_history options
    end

    # OrderList
    # Options are: from, count, from_id, end_id, order, since, end, pair, active
    def order_list options
    end

    # Trade
    # Options are: pair, type, rate, amount
    def trade options
    end

    # CancelOrder
    def cancel_order order_id
    end
  end

  module Types
    class Response
      attr_reader :success
      attr_reader :return
      attr_reader :error

      def initialize data # from JSON.parse
        @success = data["success"]
        @return = data["return"]
        @error = data["error"]
      end
    end

    class Balance
      def initialize data # from Response.return
        @funds = data["funds"].inject({}) do |arr, pair|
          arr[pair[0]] = pair[1] # arr[key] = value
          arr
        end
      end

      def amount currency
        @funds[currency]
      end
    end

    class Rights
      def info
        @rights["info"]
      end

      def trade
        @rights["trade"]
      end

      def withdraw
        @rights["withdraw"]
      end

      def initialize data # from Response.return
        @rights = data["rights"].inject({}) do |arr, pair|
          arr[pair[0]] = pair[1].zero? ? false : true # Allowed or not
        end
      end
    end

    class Stats
      attr_reader :transaction_count
      attr_reader :open_orders
      attr_reader :server_time

      def initialize data # from Response.return
        @transaction_count = data["transaction_count"]
        @open_orders = data["open_orders"]
        @server_time = data["server_time"] # UNIX timestamp
      end
    end
  end
end

# SIMPLE TEST
api = Btce::Api.new(KEY, SECRET)

puts "============================="
puts "RUR: %f" % api.balance.amount(Btce::RUR)
puts "USD: %f" % api.balance.amount(Btce::USD)
puts "LTC: %f" % api.balance.amount(Btce::LTC)
puts "BTC: %f" % api.balance.amount(Btce::BTC)
puts "============================="
puts "At: %s" % Time.at(api.stats.server_time)
