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

require 'active_support/core_ext/module/attribute_accessors'

module ActiveSupport
  # Look for and parse json strings that look like ISO 8601 times.
  mattr_accessor :parse_json_times

  module JSON
    # Listed in order of preference.
    DECODERS = %w(Yajl Yaml)

    class << self
      attr_reader :parse_error
      delegate :decode, :to => :backend

      def backend
        set_default_backend unless defined?(@backend)
        @backend
      end

      def backend=(name)
        if name.is_a?(Module)
          @backend = name
        else
          require "active_support/json/backends/#{name.to_s.downcase}.rb"
          @backend = ActiveSupport::JSON::Backends::const_get(name)
        end
        @parse_error = @backend::ParseError
      end

      def with_backend(name)
        old_backend, self.backend = backend, name
        yield
      ensure
        self.backend = old_backend
      end

      def set_default_backend
        DECODERS.find do |name|
          begin
            self.backend = name
            true
          rescue LoadError
            # Try next decoder.
            false
          end
        end
      end
    end
  end
end
