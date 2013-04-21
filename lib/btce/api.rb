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

module Btce
  class Api
    def initialize(api_key, api_secret)
      @bus = Btce::Bus.new(api_key, api_secret)
    end

    # getInfo
    def get_info
      response = Types::Response.new(JSON.parse(@bus.request({'method' => 'getInfo'})))
      raise "server responded: #{response.error}" if response.success.zero?
      response
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
    def trans_history(options = {
        :from => 0,
        :count => 1000,
        :from_id => 0,
        :end_id => nil,
        :order => :DESC, # ASC
        :since => 0,
        :end => nil
    })

      options[:method] = 'TransHistory'
      response = Types::Response.new(JSON.parse(@bus.request(options)))
      raise "server responded: #{response.error}" if response.success.zero?
      response.return.map do |id, data|
        Types::Transaction.new(id, data)
      end
    end

    # TradeHistory
    # Options are: from, count, from_id, end_id, order, since, end, pair
    def trade_history(options = {
        :from => 0,
        :count => 1000,
        :from_id => 0,
        :end_id => nil,
        :order => :DESC, # ASC
        :since => 0,
        :end => nil,
        :pair => nil
    })

      options[:method] = 'TradeHistory'
      response = Types::Response.new(JSON.parse(@bus.request(options)))
      raise "server responded: #{response.error}" if response.success.zero?
      response.return.map do |id, data|
        Types::Trade.new(id, data)
      end
    end

    # OrderList
    # Options are: from, count, from_id, end_id, order, since, end, pair, active
    def order_list(options = {
        :from => 0,
        :count => 1000,
        :from_id => 0,
        :end_id => nil,
        :order => :DESC, # ASC
        :since => 0,
        :end => nil,
        :pair => nil,
        :active => 1 # 0
    })

      options[:method] = 'OrderList'
      response = Types::Response.new(JSON.parse(@bus.request(options)))
      raise "server responded: #{response.error}" if response.success.zero?
      response.return.map do |id, data|
        Types::Order.new(id, data)
      end
    end

    # Trade
    # Parameters are: pair, type, rate, amount
    def trade(pair, type, rate, amount)
      options = {
          :pair => pair,
          :type => type,
          :rate => rate,
          :amount => amount,
          :method => 'Trade'
      }
      response = Types::Response.new(JSON.parse(@bus.request(options)))
      raise "server responded: #{response.error}" if response.success.zero?
      Types::PlacedOrder.new(self, response.return)
    end

    # CancelOrder
    def cancel_order(order_id)
      options = {
          :order_id => order_id,
          :method => 'CancelOrder'
      }

      response = Types::Response.new(JSON.parse(@bus.request(options)))
      raise "server responded: #{response.error}" if response.success.zero?
      response.return['order_id']
    end
  end
end

