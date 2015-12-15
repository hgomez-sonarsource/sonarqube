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
      module Tokyo
        include TimezoneDefinition
        
        timezone 'Asia/Tokyo' do |tz|
          tz.offset :o0, 33539, 0, :LMT
          tz.offset :o1, 32400, 0, :JST
          tz.offset :o2, 32400, 0, :CJT
          tz.offset :o3, 32400, 3600, :JDT
          
          tz.transition 1887, 12, :o1, 19285097, 8
          tz.transition 1895, 12, :o2, 19308473, 8
          tz.transition 1937, 12, :o1, 19431193, 8
          tz.transition 1948, 5, :o3, 58384157, 24
          tz.transition 1948, 9, :o1, 14596831, 6
          tz.transition 1949, 4, :o3, 58392221, 24
          tz.transition 1949, 9, :o1, 14599015, 6
          tz.transition 1950, 5, :o3, 58401797, 24
          tz.transition 1950, 9, :o1, 14601199, 6
          tz.transition 1951, 5, :o3, 58410533, 24
          tz.transition 1951, 9, :o1, 14603383, 6
        end
      end
    end
  end
end
