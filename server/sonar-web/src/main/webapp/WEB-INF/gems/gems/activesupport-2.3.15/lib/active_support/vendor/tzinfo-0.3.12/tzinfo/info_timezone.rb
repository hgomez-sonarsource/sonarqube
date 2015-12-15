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

require 'tzinfo/timezone'

module TZInfo

  # A Timezone based on a TimezoneInfo.
  class InfoTimezone < Timezone #:nodoc:
    
    # Constructs a new InfoTimezone with a TimezoneInfo instance.
    def self.new(info)      
      tz = super()
      tz.send(:setup, info)
      tz
    end
    
    # The identifier of the timezone, e.g. "Europe/Paris".
    def identifier
      @info.identifier
    end
    
    protected
      # The TimezoneInfo for this Timezone.
      def info
        @info
      end
          
      def setup(info)
        @info = info
      end
  end    
end
