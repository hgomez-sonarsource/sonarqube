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

if defined?(JRUBY_VERSION)
  begin
    tried_gem ||= false
    require 'active_record/version'
  rescue LoadError
    raise if tried_gem
    require 'rubygems'
    gem 'activerecord'
    tried_gem = true
    retry
  end
  if ActiveRecord::VERSION::MAJOR < 2
    if defined?(RAILS_CONNECTION_ADAPTERS)
      RAILS_CONNECTION_ADAPTERS << %q(jdbc)
    else
      RAILS_CONNECTION_ADAPTERS = %w(jdbc)
    end
    if ActiveRecord::VERSION::MAJOR == 1 && ActiveRecord::VERSION::MINOR == 14
      require 'arjdbc/jdbc'
    end
  else
    require 'active_record'
    require 'arjdbc/jdbc'
  end
else
  warn "activerecord-jdbc-adapter is for use with JRuby only"
end

require 'arjdbc/version'
