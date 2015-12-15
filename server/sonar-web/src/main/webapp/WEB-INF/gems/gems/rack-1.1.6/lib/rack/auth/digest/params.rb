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

module Rack
  module Auth
    module Digest
      class Params < Hash

        def self.parse(str)
          split_header_value(str).inject(new) do |header, param|
            k, v = param.split('=', 2)
            header[k] = dequote(v)
            header
          end
        end

        def self.dequote(str) # From WEBrick::HTTPUtils
          ret = (/\A"(.*)"\Z/ =~ str) ? $1 : str.dup
          ret.gsub!(/\\(.)/, "\\1")
          ret
        end

        def self.split_header_value(str)
          str.scan( /(\w+\=(?:"[^\"]+"|[^,]+))/n ).collect{ |v| v[0] }
        end

        def initialize
          super

          yield self if block_given?
        end

        def [](k)
          super k.to_s
        end

        def []=(k, v)
          super k.to_s, v.to_s
        end

        UNQUOTED = ['qop', 'nc', 'stale']

        def to_s
          inject([]) do |parts, (k, v)|
            parts << "#{k}=" + (UNQUOTED.include?(k) ? v.to_s : quote(v))
            parts
          end.join(', ')
        end

        def quote(str) # From WEBrick::HTTPUtils
          '"' << str.gsub(/[\\\"]/o, "\\\1") << '"'
        end

      end
    end
  end
end

