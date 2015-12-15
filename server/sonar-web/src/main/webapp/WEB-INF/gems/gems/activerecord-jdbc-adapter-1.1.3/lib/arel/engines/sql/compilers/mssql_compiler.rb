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

module Arel
  module SqlCompiler
    class MsSQLCompiler < GenericCompiler
      def select_sql
        projections = @relation.projections
        offset = relation.skipped
        limit = relation.taken
        if Count === projections.first && projections.size == 1 &&
          (relation.taken.present? || relation.wheres.present?) && relation.joins(self).blank?
          subquery = [
            "SELECT * FROM #{relation.from_clauses}", build_clauses
          ].join ' '
          @engine.connection.add_limit_offset!(subquery, :limit => limit, :offset => offset) if offset || limit
          query = "SELECT COUNT(*) AS count_id FROM (#{subquery}) AS subquery"
        else
          query = [
            "SELECT     #{relation.select_clauses.join(', ')}",
            "FROM       #{relation.from_clauses}",
            build_clauses
          ].compact.join ' '
          @engine.connection.add_limit_offset!(query, :limit => limit, :offset => offset) if offset || limit
        end
        query
      end

      def build_clauses
        joins   = relation.joins(self)
        wheres  = relation.where_clauses
        groups  = relation.group_clauses
        havings = relation.having_clauses
        orders  = relation.order_clauses

        clauses = [ "",
          joins,
          ("WHERE     #{wheres.join(' AND ')}" unless wheres.empty?),
          ("GROUP BY  #{groups.join(', ')}" unless groups.empty?),
          ("HAVING    #{havings.join(' AND ')}" unless havings.empty?),
          ("ORDER BY  #{orders.join(', ')}" unless orders.empty?)
        ].compact.join ' '

        clauses << " #{locked}" unless locked.blank?
        clauses unless clauses.blank?
      end
    end
  end
end
