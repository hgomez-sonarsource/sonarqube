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
    class SQLServer < Arel::Visitors::ToSql
      include ArJdbc::MsSQL::LimitHelpers::SqlServerReplaceLimitOffset

      def select_count? o
        sel = o.cores.length == 1 && o.cores.first
        projections = sel && sel.projections.length == 1 && sel.projections
        projections && Arel::Nodes::Count === projections.first
      end

      # Need to mimic the subquery logic in ARel 1.x for select count with limit
      # See arel/engines/sql/compilers/mssql_compiler.rb for details
      def visit_Arel_Nodes_SelectStatement o
        order = "ORDER BY #{o.orders.map { |x| visit x }.join(', ')}" unless o.orders.empty?
        if o.limit
          if select_count?(o)
            subquery = true
            sql = o.cores.map do |x|
              x = x.dup
              x.projections = [Arel::Nodes::SqlLiteral.new("*")]
              visit_Arel_Nodes_SelectCore x
            end.join
          else
            sql = o.cores.map { |x| visit_Arel_Nodes_SelectCore x }.join
          end

          order ||= "ORDER BY #{@connection.determine_order_clause(sql)}"
          replace_limit_offset!(sql, limit_for(o.limit).to_i, o.offset && o.offset.value.to_i, order)
          sql = "SELECT COUNT(*) AS count_id FROM (#{sql}) AS subquery" if subquery
        else
          sql = super
        end
        sql
      end
    end

    class SQLServer2000 < SQLServer
      include ArJdbc::MsSQL::LimitHelpers::SqlServer2000ReplaceLimitOffset
    end
  end
end
