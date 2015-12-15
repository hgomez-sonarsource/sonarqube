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

class ActiveRecord::Base
  class << self
    def mssql_connection(config)
      require "arjdbc/mssql"
      config[:host] ||= "localhost"
      config[:port] ||= 1433
      config[:driver] ||= "net.sourceforge.jtds.jdbc.Driver"

      url = "jdbc:jtds:sqlserver://#{config[:host]}:#{config[:port]}/#{config[:database]}"

      # Instance is often a preferrable alternative to port when dynamic ports are used.
      # If instance is specified then port is essentially ignored.
      url << ";instance=#{config[:instance]}" if config[:instance]

      # This will enable windows domain-based authentication and will require the JTDS native libraries be available.
      url << ";domain=#{config[:domain]}" if config[:domain]

      # AppName is shown in sql server as additional information against the connection.
      url << ";appname=#{config[:appname]}" if config[:appname]
      config[:url] ||= url

      if !config[:domain]
        config[:username] ||= "sa"
        config[:password] ||= ""
      end
      jdbc_connection(config)
    end
    alias_method :jdbcmssql_connection, :mssql_connection
  end
end
