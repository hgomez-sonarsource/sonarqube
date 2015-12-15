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
    module Pacific
      module Port_Moresby
        include TimezoneDefinition
        
        timezone 'Pacific/Port_Moresby' do |tz|
          tz.offset :o0, 35320, 0, :LMT
          tz.offset :o1, 35312, 0, :PMMT
          tz.offset :o2, 36000, 0, :PGT
          
          tz.transition 1879, 12, :o1, 5200664597, 2160
          tz.transition 1894, 12, :o2, 13031248093, 5400
        end
      end
    end
  end
end
