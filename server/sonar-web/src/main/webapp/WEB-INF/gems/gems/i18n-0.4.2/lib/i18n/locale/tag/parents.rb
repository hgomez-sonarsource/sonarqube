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

# encoding: utf-8

module I18n
  module Locale
    module Tag
      module Parents
        def parent
          @parent ||= begin
            segs = to_a.compact
            segs.length > 1 ? self.class.tag(*segs[0..(segs.length-2)].join('-')) : nil
          end
        end

        def self_and_parents
          @self_and_parents ||= [self] + parents
        end

        def parents
          @parents ||= ([parent] + (parent ? parent.parents : [])).compact
        end
      end
    end
  end
end
