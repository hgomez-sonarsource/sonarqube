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

require 'tzinfo/timezone_definition'

module TZInfo
  module Definitions
    module America
      module Bogota
        include TimezoneDefinition
        
        timezone 'America/Bogota' do |tz|
          tz.offset :o0, -17780, 0, :LMT
          tz.offset :o1, -17780, 0, :BMT
          tz.offset :o2, -18000, 0, :COT
          tz.offset :o3, -18000, 3600, :COST
          
          tz.transition 1884, 3, :o1, 10407954409, 4320
          tz.transition 1914, 11, :o2, 10456385929, 4320
          tz.transition 1992, 5, :o3, 704869200
          tz.transition 1993, 4, :o2, 733896000
        end
      end
    end
  end
end
