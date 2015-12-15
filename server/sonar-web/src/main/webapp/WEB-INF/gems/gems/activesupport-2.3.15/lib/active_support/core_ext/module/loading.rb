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
  # Returns String#underscore applied to the module name minus trailing classes.
  #
  #   ActiveRecord.as_load_path               # => "active_record"
  #   ActiveRecord::Associations.as_load_path # => "active_record/associations"
  #   ActiveRecord::Base.as_load_path         # => "active_record" (Base is a class)
  #
  # The Kernel module gives an empty string by definition.
  #
  #   Kernel.as_load_path # => ""
  #   Math.as_load_path   # => "math"
  def as_load_path
    if self == Object || self == Kernel
      ''
    elsif is_a? Class
      parent == self ? '' : parent.as_load_path
    else
      name.split('::').collect do |word|
        word.underscore
      end * '/'
    end
  end
end