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

require 'yaml'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module BigDecimal #:nodoc:
      module Conversions
        DEFAULT_STRING_FORMAT = 'F'.freeze
        YAML_TAG = 'tag:yaml.org,2002:float'.freeze
        YAML_MAPPING = { 'Infinity' => '.Inf', '-Infinity' => '-.Inf', 'NaN' => '.NaN' }

        def self.included(base) #:nodoc:
          base.class_eval do
            alias_method :_original_to_s, :to_s
            alias_method :to_s, :to_formatted_s

            yaml_as YAML_TAG
          end
        end

        def to_formatted_s(format = DEFAULT_STRING_FORMAT)
          _original_to_s(format)
        end

        # This emits the number without any scientific notation.
        # This is better than self.to_f.to_s since it doesn't lose precision.
        #
        # Note that reconstituting YAML floats to native floats may lose precision.
        def to_yaml(opts = {})
          YAML.quick_emit(nil, opts) do |out|
            string = to_s
            out.scalar(YAML_TAG, YAML_MAPPING[string] || string, :plain)
          end
        end
      end
    end
  end
end
