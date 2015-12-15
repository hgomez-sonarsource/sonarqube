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

require 'date'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Date #:nodoc:
      module Behavior
        # Enable more predictable duck-typing on Date-like classes. See
        # Object#acts_like?.
        def acts_like_date?
          true
        end

        # Date memoizes some instance methods using metaprogramming to wrap
        # the methods with one that caches the result in an instance variable.
        #
        # If a Date is frozen but the memoized method hasn't been called, the
        # first call will result in a frozen object error since the memo
        # instance variable is uninitialized.
        #
        # Work around by eagerly memoizing before freezing.
        #
        # Ruby 1.9 uses a preinitialized instance variable so it's unaffected.
        # This hack is as close as we can get to feature detection:
        begin
          ::Date.today.freeze.jd
        rescue => frozen_object_error
          if frozen_object_error.message =~ /frozen/
            def freeze #:nodoc:
              self.class.private_instance_methods(false).each do |m|
                if m.to_s =~ /\A__\d+__\Z/
                  instance_variable_set(:"@#{m}", [send(m)])
                end
              end

              super
            end
          end
        end
      end
    end
  end
end
