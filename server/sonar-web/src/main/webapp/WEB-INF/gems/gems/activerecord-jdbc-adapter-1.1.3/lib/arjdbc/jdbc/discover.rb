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

module ArJdbc
  def self.discover_extensions
    if defined?(::Gem) && ::Gem.respond_to?(:find_files)
      files = ::Gem.find_files('arjdbc/discover')
    else
      files = $LOAD_PATH.map do |p|
        discover = File.join(p, 'arjdbc','discover.rb')
        File.exist?(discover) ? discover : nil
      end.compact
    end
    files.each do |f|
      puts "Loading #{f}" if $DEBUG
      require f
    end
  end

  discover_extensions
end
