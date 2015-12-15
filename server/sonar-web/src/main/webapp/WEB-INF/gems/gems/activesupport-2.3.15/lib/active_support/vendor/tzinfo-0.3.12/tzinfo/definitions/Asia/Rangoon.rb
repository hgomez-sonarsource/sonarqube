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
    module Asia
      module Rangoon
        include TimezoneDefinition
        
        timezone 'Asia/Rangoon' do |tz|
          tz.offset :o0, 23080, 0, :LMT
          tz.offset :o1, 23076, 0, :RMT
          tz.offset :o2, 23400, 0, :BURT
          tz.offset :o3, 32400, 0, :JST
          tz.offset :o4, 23400, 0, :MMT
          
          tz.transition 1879, 12, :o1, 5200664903, 2160
          tz.transition 1919, 12, :o2, 5813578159, 2400
          tz.transition 1942, 4, :o3, 116663051, 48
          tz.transition 1945, 5, :o4, 19452625, 8
        end
      end
    end
  end
end
