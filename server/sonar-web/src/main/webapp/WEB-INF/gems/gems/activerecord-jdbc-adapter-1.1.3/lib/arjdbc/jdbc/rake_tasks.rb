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

if defined?(Rake.application) && Rake.application && ENV["SKIP_AR_JDBC_RAKE_REDEFINES"].nil?
  jdbc_rakefile = File.dirname(__FILE__) + "/jdbc.rake"
  if Rake.application.lookup("db:create")
    # rails tasks already defined; load the override tasks now
    load jdbc_rakefile
  else
    # rails tasks not loaded yet; load as an import
    Rake.application.add_import(jdbc_rakefile)
  end
end
