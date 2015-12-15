#
# SonarQube
# Copyright (C) 2009-2016 SonarSource SA
# mailto:contact AT sonarsource DOT com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

require 'digest/md5'

module Rack
  module Auth
    module Digest
      # Rack::Auth::Digest::Nonce is the default nonce generator for the
      # Rack::Auth::Digest::MD5 authentication handler.
      #
      # +private_key+ needs to set to a constant string.
      #
      # +time_limit+ can be optionally set to an integer (number of seconds),
      # to limit the validity of the generated nonces.

      class Nonce

        class << self
          attr_accessor :private_key, :time_limit
        end

        def self.parse(string)
          new(*string.unpack("m*").first.split(' ', 2))
        end

        def initialize(timestamp = Time.now, given_digest = nil)
          @timestamp, @given_digest = timestamp.to_i, given_digest
        end

        def to_s
          [([ @timestamp, digest ] * ' ')].pack("m*").strip
        end

        def digest
          ::Digest::MD5.hexdigest([ @timestamp, self.class.private_key ] * ':')
        end

        def valid?
          digest == @given_digest
        end

        def stale?
          !self.class.time_limit.nil? && (@timestamp - Time.now.to_i) < self.class.time_limit
        end

        def fresh?
          !stale?
        end

      end
    end
  end
end
