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

require 'set'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Return a hash that includes everything but the given keys. This is useful for
      # limiting a set of parameters to everything but a few known toggles:
      #
      #   @person.update_attributes(params[:person].except(:admin))
      module Except
        # Returns a new hash without the given keys.
        def except(*keys)
          dup.except!(*keys)
        end

        # Replaces the hash without the given keys.
        def except!(*keys)
          keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
          keys.each { |key| delete(key) }
          self
        end
      end
    end
  end
end
