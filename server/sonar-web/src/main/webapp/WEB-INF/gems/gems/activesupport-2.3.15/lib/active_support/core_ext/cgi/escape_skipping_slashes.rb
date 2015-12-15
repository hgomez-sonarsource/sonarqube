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
    module CGI #:nodoc:
      module EscapeSkippingSlashes #:nodoc:
        if RUBY_VERSION >= '1.9'
          def escape_skipping_slashes(str)
            str = str.join('/') if str.respond_to? :join
            str.gsub(/([^ \/a-zA-Z0-9_.-])/n) do
              "%#{$1.unpack('H2' * $1.bytesize).join('%').upcase}"
            end.tr(' ', '+')
          end
        else
          def escape_skipping_slashes(str)
            str = str.join('/') if str.respond_to? :join
            str.gsub(/([^ \/a-zA-Z0-9_.-])/n) do
              "%#{$1.unpack('H2').first.upcase}"
            end.tr(' ', '+')
          end
        end
      end
    end
  end
end
