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
    module Africa
      module Johannesburg
        include TimezoneDefinition
        
        timezone 'Africa/Johannesburg' do |tz|
          tz.offset :o0, 6720, 0, :LMT
          tz.offset :o1, 5400, 0, :SAST
          tz.offset :o2, 7200, 0, :SAST
          tz.offset :o3, 7200, 3600, :SAST
          
          tz.transition 1892, 2, :o1, 108546139, 45
          tz.transition 1903, 2, :o2, 38658791, 16
          tz.transition 1942, 9, :o3, 4861245, 2
          tz.transition 1943, 3, :o2, 58339307, 24
          tz.transition 1943, 9, :o3, 4861973, 2
          tz.transition 1944, 3, :o2, 58348043, 24
        end
      end
    end
  end
end
