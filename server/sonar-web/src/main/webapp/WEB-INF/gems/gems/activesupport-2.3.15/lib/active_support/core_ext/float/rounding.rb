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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Float #:nodoc:
      module Rounding
        def self.included(base) #:nodoc:
          base.class_eval do
            alias_method :round_without_precision, :round
            alias_method :round, :round_with_precision
          end
        end

        # Rounds the float with the specified precision.
        #
        #   x = 1.337
        #   x.round    # => 1
        #   x.round(1) # => 1.3
        #   x.round(2) # => 1.34
        def round_with_precision(precision = nil)
          precision.nil? ? round_without_precision : (self * (10 ** precision)).round / (10 ** precision).to_f
        end
      end
    end
  end
end
