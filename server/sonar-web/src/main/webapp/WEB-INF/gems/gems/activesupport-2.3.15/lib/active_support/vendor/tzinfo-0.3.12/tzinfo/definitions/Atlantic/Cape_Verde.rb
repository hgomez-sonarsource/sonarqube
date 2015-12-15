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
    module Atlantic
      module Cape_Verde
        include TimezoneDefinition
        
        timezone 'Atlantic/Cape_Verde' do |tz|
          tz.offset :o0, -5644, 0, :LMT
          tz.offset :o1, -7200, 0, :CVT
          tz.offset :o2, -7200, 3600, :CVST
          tz.offset :o3, -3600, 0, :CVT
          
          tz.transition 1907, 1, :o1, 52219653811, 21600
          tz.transition 1942, 9, :o2, 29167243, 12
          tz.transition 1945, 10, :o1, 58361845, 24
          tz.transition 1975, 11, :o3, 186120000
        end
      end
    end
  end
end
