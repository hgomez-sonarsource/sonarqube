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

require 'yajl' unless defined?(Yajl)

module ActiveSupport
  module JSON
    module Backends
      module Yajl
        ParseError = ::Yajl::ParseError
        extend self

        # Parses a JSON string or IO and convert it into an object
        def decode(json)
          data = ::Yajl::Parser.new.parse(json)
          if ActiveSupport.parse_json_times
            convert_dates_from(data)
          else
            data
          end
        end

      private
        def convert_dates_from(data)
          case data
          when nil
            nil
          when DATE_REGEX
            DateTime.parse(data)
          when Array
            data.map! { |d| convert_dates_from(d) }
          when Hash
            data.each do |key, value|
              data[key] = convert_dates_from(value)
            end
          else
            data
          end
        end
      end
    end
  end
end
