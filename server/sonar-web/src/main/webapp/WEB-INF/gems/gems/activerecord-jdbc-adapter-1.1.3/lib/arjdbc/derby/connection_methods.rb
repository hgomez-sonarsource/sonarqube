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
  class Base
    class << self
      def derby_connection(config)
        config[:url] ||= "jdbc:derby:#{config[:database]};create=true"
        config[:driver] ||= "org.apache.derby.jdbc.EmbeddedDriver"
        conn = embedded_driver(config)
        md = conn.jdbc_connection.meta_data
        if md.database_major_version < 10 || (md.database_major_version == 10 && md.database_minor_version < 5)
          raise ::ActiveRecord::ConnectionFailed, "Derby adapter requires Derby 10.5 or later"
        end
        conn
      end

      alias_method :jdbcderby_connection, :derby_connection
    end
  end
end
