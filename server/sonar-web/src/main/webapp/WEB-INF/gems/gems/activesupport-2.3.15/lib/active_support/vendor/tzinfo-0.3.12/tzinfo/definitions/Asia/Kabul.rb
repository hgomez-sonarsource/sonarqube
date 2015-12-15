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
      module Kabul
        include TimezoneDefinition
        
        timezone 'Asia/Kabul' do |tz|
          tz.offset :o0, 16608, 0, :LMT
          tz.offset :o1, 14400, 0, :AFT
          tz.offset :o2, 16200, 0, :AFT
          
          tz.transition 1889, 12, :o1, 2170231477, 900
          tz.transition 1944, 12, :o2, 7294369, 3
        end
      end
    end
  end
end
