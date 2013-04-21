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
  class Bus
    def initialize(api_key, api_secret)
      @api_key = api_key
      @api_secret = api_secret
      @nonce = 0
    end

    def request(data)
      # Timestamp for the request
      data[:nonce] = Time::now.to_i + @nonce
      @nonce += 1

      # Form parametrized string
      postdata = data.collect do |key, value|
        "#{key}=#{CGI::escape(value.to_s)}"
      end.join('&')

      # Open HTTPS connection
      Net::HTTP.start(Btce::Api::HOST, Btce::Api::PORT, :use_ssl => true) do |http|
        # Headers setup
        headers = {
            'Sign' => sign(postdata),
            'Key' => @api_key,
            'User-Agent' => Btce::Api::AGENT
        }

        # Send signed data
        return http.post(Btce::Api::API_URL, postdata, headers).body
      end
    end

    def sign(data)
      # Sign data with the HMAC SHA-512 algorhythm
      # Read https://btc-e.com/defines/documentation
      OpenSSL::HMAC.hexdigest(Btce::Api::HMAC_SHA, @api_secret, data)
    end
  end
end
