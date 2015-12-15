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

require 'arel/visitors/compat'

module Arel
  module Visitors
    class Firebird < Arel::Visitors::ToSql
      def visit_Arel_Nodes_SelectStatement o
        [
         o.cores.map { |x| visit_Arel_Nodes_SelectCore x }.join,
         ("ORDER BY #{o.orders.map { |x| visit x }.join(', ')}" unless o.orders.empty?),
         ("ROWS #{limit_for(o.limit)} " if o.limit),
         ("TO #{o.offset} " if o.offset),
        ].compact.join ' '
      end

    end
  end
end
