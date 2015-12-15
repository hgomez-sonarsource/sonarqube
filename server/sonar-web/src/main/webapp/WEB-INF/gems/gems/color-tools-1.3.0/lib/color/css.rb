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

require 'color'

  # This namespace contains some CSS colour names.
module Color::CSS
    # Returns the RGB colour for name or +nil+ if the name is not valid.
  def self.[](name)
    @colors[name.to_s.downcase.to_sym]
  end

  @colors = {}
  Color::RGB.constants.each do |const|
    next if const == "PDF_FORMAT_STR"
    next if const == "Metallic"
    @colors[const.downcase.to_sym] ||= Color::RGB.const_get(const)
  end
end
