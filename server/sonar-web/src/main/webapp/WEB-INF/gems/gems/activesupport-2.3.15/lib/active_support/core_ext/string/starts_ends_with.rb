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
      # Additional string tests.
      module StartsEndsWith
        def self.append_features(base)
          if '1.8.7 and up'.respond_to?(:start_with?)
            base.class_eval do
              alias_method :starts_with?, :start_with?
              alias_method :ends_with?, :end_with?
            end
          else
            super
            base.class_eval do
              alias_method :start_with?, :starts_with?
              alias_method :end_with?, :ends_with?
            end
          end
        end

        # Does the string start with the specified +prefix+?
        def starts_with?(prefix)
          prefix.respond_to?(:to_str) && self[0, prefix.length] == prefix
        end

        # Does the string end with the specified +suffix+?
        def ends_with?(suffix)
          suffix.respond_to?(:to_str) && self[-suffix.length, suffix.length] == suffix
        end
      end
    end
  end
end
