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
      module Phoenix
        include TimezoneDefinition
        
        timezone 'America/Phoenix' do |tz|
          tz.offset :o0, -26898, 0, :LMT
          tz.offset :o1, -25200, 0, :MST
          tz.offset :o2, -25200, 3600, :MDT
          tz.offset :o3, -25200, 3600, :MWT
          
          tz.transition 1883, 11, :o1, 57819199, 24
          tz.transition 1918, 3, :o2, 19373471, 8
          tz.transition 1918, 10, :o1, 14531363, 6
          tz.transition 1919, 3, :o2, 19376383, 8
          tz.transition 1919, 10, :o1, 14533547, 6
          tz.transition 1942, 2, :o3, 19443199, 8
          tz.transition 1944, 1, :o1, 3500770681, 1440
          tz.transition 1944, 4, :o3, 3500901781, 1440
          tz.transition 1944, 10, :o1, 3501165241, 1440
          tz.transition 1967, 4, :o2, 19516887, 8
          tz.transition 1967, 10, :o1, 14638757, 6
        end
      end
    end
  end
end
