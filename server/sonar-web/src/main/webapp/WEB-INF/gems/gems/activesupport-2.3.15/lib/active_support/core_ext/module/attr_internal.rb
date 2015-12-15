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

class Module
  # Declares an attribute reader backed by an internally-named instance variable.
  def attr_internal_reader(*attrs)
    attrs.each do |attr|
      module_eval "def #{attr}() #{attr_internal_ivar_name(attr)} end"
    end
  end

  # Declares an attribute writer backed by an internally-named instance variable.
  def attr_internal_writer(*attrs)
    attrs.each do |attr|
      module_eval "def #{attr}=(v) #{attr_internal_ivar_name(attr)} = v end"
    end
  end

  # Declares an attribute reader and writer backed by an internally-named instance
  # variable.
  def attr_internal_accessor(*attrs)
    attr_internal_reader(*attrs)
    attr_internal_writer(*attrs)
  end

  alias_method :attr_internal, :attr_internal_accessor

  private
    mattr_accessor :attr_internal_naming_format
    self.attr_internal_naming_format = '@_%s'

    def attr_internal_ivar_name(attr)
      attr_internal_naming_format % attr
    end
end
