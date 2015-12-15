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

min_release  = "1.8.2 (2004-12-25)"
ruby_release = "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE})"
if ruby_release =~ /1\.8\.3/
  abort <<-end_message

    Rails does not work with Ruby version 1.8.3.
    Please upgrade to version 1.8.4 or downgrade to 1.8.2.

  end_message
elsif ruby_release < min_release
  abort <<-end_message

    Rails requires Ruby version #{min_release} or later.
    You're running #{ruby_release}; please upgrade to continue.

  end_message
end
