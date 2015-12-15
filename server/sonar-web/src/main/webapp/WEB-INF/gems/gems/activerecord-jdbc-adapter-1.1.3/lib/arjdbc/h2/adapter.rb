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

require 'arjdbc/hsqldb/adapter'

module ArJdbc
  module H2
    include HSQLDB

    def self.jdbc_connection_class
      ::ActiveRecord::ConnectionAdapters::H2JdbcConnection
    end

    def adapter_name #:nodoc:
      'H2'
    end

    def arel2_visitors
      super.merge 'h2' => ::Arel::Visitors::HSQLDB, 'jdbch2' => ::Arel::Visitors::HSQLDB
    end

    def h2_adapter
      true
    end

    def tables
      @connection.tables(nil, h2_schema)
    end

    def columns(table_name, name=nil)
      @connection.columns_internal(table_name.to_s, name, h2_schema)
    end

    private
    def h2_schema
      @config[:schema] || ''
    end
  end
end
