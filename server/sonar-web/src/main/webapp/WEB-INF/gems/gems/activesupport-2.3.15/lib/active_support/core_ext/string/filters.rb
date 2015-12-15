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
    module String #:nodoc:
      module Filters
        # Returns the string, first removing all whitespace on both ends of
        # the string, and then changing remaining consecutive whitespace
        # groups into one space each.
        #
        # Examples:
        #   %{ Multi-line
        #      string }.squish                   # => "Multi-line string"
        #   " foo   bar    \n   \t   boo".squish # => "foo bar boo"
        def squish
          dup.squish!
        end

        # Performs a destructive squish. See String#squish.
        def squish!
          strip!
          gsub!(/\s+/, ' ')
          self
        end
      end
    end
  end
end
