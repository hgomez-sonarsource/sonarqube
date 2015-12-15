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

# arjdbc/discover.rb: Declare ArJdbc.extension modules in this file
# that loads a custom module and adapter.

module ::ArJdbc
  # Adapters built-in to AR are required up-front so we can override
  # the native ones
  require 'arjdbc/mysql'
  extension :MySQL do |name|
    name =~ /mysql/i
  end

  require 'arjdbc/postgresql'
  extension :PostgreSQL do |name|
    name =~ /postgre/i
  end

  require 'arjdbc/sqlite3'
  extension :SQLite3 do |name|
    name =~ /sqlite/i
  end

  # Other adapters are lazy-loaded
  extension :DB2 do |name, config|
    if name =~ /(db2|as400)/i && config[:url] !~ /^jdbc:derby:net:/
      require 'arjdbc/db2'
      true
    end
  end

  extension :Derby do |name|
    if name =~ /derby/i
      require 'arjdbc/derby'
      true
    end
  end

  extension :FireBird do |name|
    if name =~ /firebird/i
      require 'arjdbc/firebird'
      true
    end
  end

  extension :H2 do |name|
    if name =~ /\.h2\./i
      require 'arjdbc/h2'
      true
    end
  end

  extension :HSQLDB do |name|
    if name =~ /hsqldb/i
      require 'arjdbc/hsqldb'
      true
    end
  end

  extension :Informix do |name|
    if name =~ /informix/i
      require 'arjdbc/informix'
      true
    end
  end

  extension :Mimer do |name|
    if name =~ /mimer/i
      require 'arjdbc/mimer'
      true
    end
  end

  extension :MsSQL do |name|
    if name =~ /sqlserver|tds|Microsoft SQL/i
      require 'arjdbc/mssql'
      true
    end
  end

  extension :Oracle do |name|
    if name =~ /oracle/i
      require 'arjdbc/oracle'
      true
    end
  end

  extension :Sybase do |name|
    if name =~ /sybase|tds/i
      require 'arjdbc/sybase'
      true
    end
  end
end
