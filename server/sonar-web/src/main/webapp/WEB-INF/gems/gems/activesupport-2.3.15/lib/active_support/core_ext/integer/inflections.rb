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

require 'active_support/inflector'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Integer #:nodoc:
      module Inflections
        # Ordinalize turns a number into an ordinal string used to denote the
        # position in an ordered sequence such as 1st, 2nd, 3rd, 4th.
        #
        #   1.ordinalize    # => "1st"
        #   2.ordinalize    # => "2nd"
        #   1002.ordinalize # => "1002nd"
        #   1003.ordinalize # => "1003rd"
        def ordinalize
          Inflector.ordinalize(self)
        end
      end
    end
  end
end
