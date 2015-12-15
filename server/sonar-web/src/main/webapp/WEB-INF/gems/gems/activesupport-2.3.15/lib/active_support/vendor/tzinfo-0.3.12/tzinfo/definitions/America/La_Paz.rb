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
      module La_Paz
        include TimezoneDefinition
        
        timezone 'America/La_Paz' do |tz|
          tz.offset :o0, -16356, 0, :LMT
          tz.offset :o1, -16356, 0, :CMT
          tz.offset :o2, -16356, 3600, :BOST
          tz.offset :o3, -14400, 0, :BOT
          
          tz.transition 1890, 1, :o1, 17361854563, 7200
          tz.transition 1931, 10, :o2, 17471733763, 7200
          tz.transition 1932, 3, :o3, 17472871063, 7200
        end
      end
    end
  end
end
