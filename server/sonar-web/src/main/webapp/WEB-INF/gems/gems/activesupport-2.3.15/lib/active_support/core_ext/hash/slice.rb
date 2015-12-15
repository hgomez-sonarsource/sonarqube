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
    module Hash #:nodoc:
      # Slice a hash to include only the given keys. This is useful for
      # limiting an options hash to valid keys before passing to a method:
      #
      #   def search(criteria = {})
      #     assert_valid_keys(:mass, :velocity, :time)
      #   end
      #
      #   search(options.slice(:mass, :velocity, :time))
      #
      # If you have an array of keys you want to limit to, you should splat them:
      #
      #   valid_keys = [:mass, :velocity, :time]
      #   search(options.slice(*valid_keys))
      module Slice
        # Returns a new hash with only the given keys.
        def slice(*keys)
          keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
          hash = self.class.new
          keys.each { |k| hash[k] = self[k] if has_key?(k) }
          hash
        end

        # Replaces the hash with only the given keys.
        # Returns a hash contained the removed key/value pairs
        #   {:a => 1, :b => 2, :c => 3, :d => 4}.slice!(:a, :b) # => {:c => 3, :d =>4}
        def slice!(*keys)
          keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
          omit = slice(*self.keys - keys)
          hash = slice(*keys)
          replace(hash)
          omit
        end
      end
    end
  end
end

