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
      module Guam
        include TimezoneDefinition
        
        timezone 'Pacific/Guam' do |tz|
          tz.offset :o0, -51660, 0, :LMT
          tz.offset :o1, 34740, 0, :LMT
          tz.offset :o2, 36000, 0, :GST
          tz.offset :o3, 36000, 0, :ChST
          
          tz.transition 1844, 12, :o1, 1149567407, 480
          tz.transition 1900, 12, :o2, 1159384847, 480
          tz.transition 2000, 12, :o3, 977493600
        end
      end
    end
  end
end
