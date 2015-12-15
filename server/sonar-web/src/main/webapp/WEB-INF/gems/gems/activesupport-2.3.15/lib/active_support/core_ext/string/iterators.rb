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

require 'strscan'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module String #:nodoc:
      # Custom string iterators
      module Iterators
        def self.append_features(base)
          super unless '1.9'.respond_to?(:each_char)
        end

        # Yields a single-character string for each character in the string.
        # When $KCODE = 'UTF8', multi-byte characters are yielded appropriately.
        def each_char
          scanner, char = StringScanner.new(self), /./mu
          while c = scanner.scan(char)
            yield c
          end
        end
      end
    end
  end
end
