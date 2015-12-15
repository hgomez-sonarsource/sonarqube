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

# Don't need to load native mysql adapter
$LOADED_FEATURES << "active_record/connection_adapters/mysql_adapter.rb"
$LOADED_FEATURES << "active_record/connection_adapters/mysql2_adapter.rb"

class ActiveRecord::Base
  class << self
    def mysql_connection(config)
      require "arjdbc/mysql"
      config[:port] ||= 3306
      options = (config[:options] ||= {})
      options['zeroDateTimeBehavior'] ||= 'convertToNull'
      options['jdbcCompliantTruncation'] ||= 'false'
      options['useUnicode'] ||= 'true'
      options['characterEncoding'] = config[:encoding] || 'utf8'
      config[:url] ||= "jdbc:mysql://#{config[:host]}:#{config[:port]}/#{config[:database]}"
      config[:driver] ||= "com.mysql.jdbc.Driver"
      config[:adapter_class] = ActiveRecord::ConnectionAdapters::MysqlAdapter
      connection = jdbc_connection(config)
      ::ArJdbc::MySQL.kill_cancel_timer(connection.raw_connection)
      connection
    end
    alias_method :jdbcmysql_connection, :mysql_connection
    alias_method :mysql2_connection, :mysql_connection
  end
end


