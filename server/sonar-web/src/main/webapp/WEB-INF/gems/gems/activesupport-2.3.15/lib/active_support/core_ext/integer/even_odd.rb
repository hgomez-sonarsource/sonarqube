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
    module Integer #:nodoc:
      # For checking if a fixnum is even or odd.
      #
      #   2.even?  # => true
      #   2.odd?   # => false
      #   1.even?  # => false
      #   1.odd?   # => true
      #   0.even?  # => true
      #   0.odd?   # => false
      #   -1.even? # => false
      #   -1.odd?  # => true
      module EvenOdd
        def multiple_of?(number)
          self % number == 0
        end

        def even?
          multiple_of? 2
        end if RUBY_VERSION < '1.9'

        def odd?
          !even?
        end if RUBY_VERSION < '1.9'
      end
    end
  end
end
