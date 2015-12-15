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
      module Midway
        include TimezoneDefinition
        
        timezone 'Pacific/Midway' do |tz|
          tz.offset :o0, -42568, 0, :LMT
          tz.offset :o1, -39600, 0, :NST
          tz.offset :o2, -39600, 3600, :NDT
          tz.offset :o3, -39600, 0, :BST
          tz.offset :o4, -39600, 0, :SST
          
          tz.transition 1901, 1, :o1, 26086168721, 10800
          tz.transition 1956, 6, :o2, 58455071, 24
          tz.transition 1956, 9, :o1, 29228627, 12
          tz.transition 1967, 4, :o3, 58549967, 24
          tz.transition 1983, 11, :o4, 439038000
        end
      end
    end
  end
end
