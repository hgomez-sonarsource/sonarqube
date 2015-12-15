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

module Kernel
  # load a JDBC driver library/gem, failing silently. If failed, trust
  # that the driver jar is already present through some other means
  def jdbc_require_driver(path, gem_name = nil)
    gem_name ||= path.sub('/', '-')
    2.times do
      begin
        require path
        break
      rescue LoadError
        require 'rubygems'
        begin; gem gem_name; rescue LoadError; end
      end
    end
  end
end
