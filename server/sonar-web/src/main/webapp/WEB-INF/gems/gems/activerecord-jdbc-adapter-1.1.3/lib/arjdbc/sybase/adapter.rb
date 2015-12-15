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

module ArJdbc
  module Sybase
    def add_limit_offset!(sql, options) # :nodoc:
      @limit = options[:limit]
      @offset = options[:offset]
      if use_temp_table?
        # Use temp table to hack offset with Sybase
        sql.sub!(/ FROM /i, ' INTO #artemp FROM ')
      elsif zero_limit?
        # "SET ROWCOUNT 0" turns off limits, so we havesy
        # to use a cheap trick.
        if sql =~ /WHERE/i
          sql.sub!(/WHERE/i, 'WHERE 1 = 2 AND ')
        elsif sql =~ /ORDER\s+BY/i
          sql.sub!(/ORDER\s+BY/i, 'WHERE 1 = 2 ORDER BY')
        else
          sql << 'WHERE 1 = 2'
        end
      end
    end

    # If limit is not set at all, we can ignore offset;
    # if limit *is* set but offset is zero, use normal select
    # with simple SET ROWCOUNT.  Thus, only use the temp table
    # if limit is set and offset > 0.
    def use_temp_table?
      !@limit.nil? && !@offset.nil? && @offset > 0
    end

    def zero_limit?
      !@limit.nil? && @limit == 0
    end

    def modify_types(tp) #:nodoc:
      tp[:primary_key] = "NUMERIC(22,0) IDENTITY PRIMARY KEY"
      tp[:integer][:limit] = nil
      tp[:boolean] = {:name => "bit"}
      tp[:binary] = {:name => "image"}
      tp
    end

    def remove_index(table_name, options = {})
      execute "DROP INDEX #{table_name}.#{index_name(table_name, options)}"
    end
  end
end
