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
      # Allows for reverse merging two hashes where the keys in the calling hash take precedence over those
      # in the <tt>other_hash</tt>. This is particularly useful for initializing an option hash with default values:
      #
      #   def setup(options = {})
      #     options.reverse_merge! :size => 25, :velocity => 10
      #   end
      #
      # Using <tt>merge</tt>, the above example would look as follows:
      #
      #   def setup(options = {})
      #     { :size => 25, :velocity => 10 }.merge(options)
      #   end
      #
      # The default <tt>:size</tt> and <tt>:velocity</tt> are only set if the +options+ hash passed in doesn't already
      # have the respective key.
      module ReverseMerge
        # Performs the opposite of <tt>merge</tt>, with the keys and values from the first hash taking precedence over the second.
        def reverse_merge(other_hash)
          other_hash.merge(self)
        end

        # Performs the opposite of <tt>merge</tt>, with the keys and values from the first hash taking precedence over the second.
        # Modifies the receiver in place.
        def reverse_merge!(other_hash)
          replace(reverse_merge(other_hash))
        end

        alias_method :reverse_update, :reverse_merge!
      end
    end
  end
end
