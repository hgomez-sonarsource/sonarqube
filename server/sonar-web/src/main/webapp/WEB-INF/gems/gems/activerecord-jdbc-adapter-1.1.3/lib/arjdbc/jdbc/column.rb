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
  module ConnectionAdapters
    class JdbcColumn < Column
      attr_writer :limit, :precision

      def initialize(config, name, default, *args)
        call_discovered_column_callbacks(config)
        super(name,default_value(default),*args)
        init_column(name, default, *args)
      end

      def init_column(*args)
      end

      def default_value(val)
        val
      end

      def self.column_types
        # GH #25: reset the column types if the # of constants changed
        # since last call
        if ::ArJdbc.constants.size != driver_constants.size
          @driver_constants = nil
          @column_types = nil
        end
        @column_types ||= driver_constants.select {|c|
          c.respond_to? :column_selector }.map {|c|
          c.column_selector }.inject({}) {|h,val|
          h[val[0]] = val[1]; h }
      end

      def self.driver_constants
        @driver_constants ||= ::ArJdbc.constants.map {|c| ::ArJdbc.const_get c }
      end

      protected
      def call_discovered_column_callbacks(config)
        dialect = config[:dialect] || config[:driver]
        for reg, func in JdbcColumn.column_types
          if reg === dialect.to_s
            func.call(config,self)
          end
        end
      end
    end
  end
end
