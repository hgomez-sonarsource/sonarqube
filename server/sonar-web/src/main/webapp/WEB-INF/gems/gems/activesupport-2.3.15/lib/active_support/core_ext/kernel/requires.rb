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
  # Require a library with fallback to RubyGems.  Warnings during library
  # loading are silenced to increase signal/noise for application warnings.
  def require_library_or_gem(library_name)
    silence_warnings do
      begin
        require library_name
      rescue LoadError => cannot_require
        # 1. Requiring the module is unsuccessful, maybe it's a gem and nobody required rubygems yet. Try.
        begin
          require 'rubygems'
        rescue LoadError => rubygems_not_installed
          raise cannot_require
        end
        # 2. Rubygems is installed and loaded. Try to load the library again
        begin
          require library_name
        rescue LoadError => gem_not_installed
          raise cannot_require
        end
      end
    end
  end
end