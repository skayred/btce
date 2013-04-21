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
  module Types
    class Response
      attr_reader :success
      attr_reader :return
      attr_reader :error

      def initialize(data) # from JSON.parse
        @success = data['success']
        @return = data['return']
        @error = data['error']
      end
    end

    class Balance
      def initialize(data) # from Response.return
        @funds = data['funds']
      end

      def amount(currency)
        @funds[currency]
      end

      def to_s
        @funds.to_s
      end
    end

    class Rights
      def info?
        @rights['info'].zero? ? false : true
      end

      def trade?
        @rights['trade'].zero? ? false : true
      end

      def withdraw?
        @rights['withdraw'].zero? ? false : true
      end

      def initialize(data) # from Response.return
        @rights = data['rights']
      end

      def to_s
        @rights.to_s
      end
    end

    class Stats
      attr_reader :transaction_count, :open_orders, :server_time

      def initialize(data) # from Response.return
        @transaction_count = data['transaction_count']
        @open_orders = data['open_orders']
        @server_time = data['server_time'] # UNIX timestamp
      end
    end

    class Transaction
      attr_reader :id, :type, :amount, :currency, :desc, :status, :timestamp

      def initialize(id, data) # from Response.return
        @values = data
        @values[:id] = id
        @values.each { |name, value| instance_variable_set("@#{name}", value) }
      end

      def to_s
        @values.to_s
      end
    end

    class Trade
      attr_reader :id, :pair, :type, :amount, :rate, :order_id, :is_your_order, :timestamp

      def initialize(id, data) # from Response.return
        data.delete('funds')
        @values = data
        @values[:id] = id
        @values.each { |name, value| instance_variable_set("@#{name}", value) }
      end

      def to_s
        @values.to_s
      end
    end

    class Order
      attr_reader :id, :pair, :type, :amount, :rate, :timestamp_created, :status

      def initialize(id, data) # from Response.return
        @values = data
        @values[:id] = id
        @values.each { |name, value| instance_variable_set("@#{name}", value) }
      end

      def active?
        @values['status'].zero? ? false : true
      end

      def to_s
        @values.to_s
      end
    end

    class PlacedOrder
      attr_reader :received, :remains, :order_id

      def initialize(api, data) # from Response.return
        @api = api
        data.delete('funds')
        @values = data
        @values.each { |name, value| instance_variable_set("@#{name}", value) }
      end

      def cancel
        @api.cancel_order @values[:order_id]
      end

      def to_s
        @values.to_s
      end
    end
  end
end