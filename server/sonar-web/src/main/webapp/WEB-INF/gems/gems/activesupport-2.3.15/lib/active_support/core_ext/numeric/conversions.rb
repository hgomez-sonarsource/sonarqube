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
    module Numeric #:nodoc:
      module Conversions
        # Assumes self represents an offset from UTC in seconds (as returned from Time#utc_offset)
        # and turns this into an +HH:MM formatted string. Example:
        #
        #   -21_600.to_utc_offset_s   # => "-06:00"
        def to_utc_offset_s(colon=true)
          seconds = self
          sign = (seconds < 0 ? '-' : '+')
          hours = seconds.abs / 3600
          minutes = (seconds.abs % 3600) / 60
          "%s%02d%s%02d" % [ sign, hours, colon ? ":" : "", minutes ]
        end
      end
    end
  end
end
