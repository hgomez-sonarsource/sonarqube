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

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module DatabaseLimits

      # the maximum length of a table alias
      def table_alias_length
        255
      end

      # the maximum length of a column name
      def column_name_length
        64
      end

      # the maximum length of a table name
      def table_name_length
        64
      end

      # the maximum length of an index name
      def index_name_length
        64
      end

      # the maximum number of columns per table
      def columns_per_table
        1024
      end

      # the maximum number of indexes per table
      def indexes_per_table
        16
      end

      # the maximum number of columns in a multicolumn index
      def columns_per_multicolumn_index
        16
      end

      # the maximum number of elements in an IN (x,y,z) clause
      def in_clause_length
        65535
      end

      # the maximum length of a SQL query
      def sql_query_length
        1048575
      end

      # maximum number of joins in a single query
      def joins_per_query
        256
      end

    end
  end
end
