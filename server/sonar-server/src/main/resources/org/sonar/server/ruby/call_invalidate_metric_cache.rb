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

# this script defines a method which calls the class method "clear_cache" of the Metric class defined
# in /server/sonar-web/src/main/webapp/WEB-INF/app/models/metric.rb

class RbCallInvalidateMetricCache
  include Java::org.sonar.server.ruby.CallInvalidateMetricCache
  def call_invalidate
    Metric.clear_cache
  end
end
RbCallInvalidateMetricCache.new
