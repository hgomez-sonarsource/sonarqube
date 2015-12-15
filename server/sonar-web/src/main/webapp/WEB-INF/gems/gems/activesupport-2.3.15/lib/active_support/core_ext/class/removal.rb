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

class Class #:nodoc:
  
  # Unassociates the class with its subclasses and removes the subclasses
  # themselves.
  #
  #   Integer.remove_subclasses # => [Bignum, Fixnum]
  #   Fixnum                    # => NameError: uninitialized constant Fixnum
  def remove_subclasses
    Object.remove_subclasses_of(self)
  end

  # Returns an array with the names of the subclasses of +self+ as strings.
  #
  #   Integer.subclasses # => ["Bignum", "Fixnum"]
  def subclasses
    Object.subclasses_of(self).map { |o| o.to_s }
  end

  # Removes the classes in +klasses+ from their parent module.
  #
  # Ordinary classes belong to some module via a constant. This method computes
  # that constant name from the class name and removes it from the module it
  # belongs to.
  #
  #   Object.remove_class(Integer) # => [Integer]
  #   Integer                      # => NameError: uninitialized constant Integer
  #
  # Take into account that in general the class object could be still stored
  # somewhere else.
  #
  #   i = Integer                  # => Integer
  #   Object.remove_class(Integer) # => [Integer]
  #   Integer                      # => NameError: uninitialized constant Integer
  #   i.subclasses                 # => ["Bignum", "Fixnum"]
  #   Fixnum.superclass            # => Integer
  def remove_class(*klasses)
    klasses.flatten.each do |klass|
      # Skip this class if there is nothing bound to this name
      next unless defined?(klass.name)
      
      basename = klass.to_s.split("::").last
      parent = klass.parent
      
      # Skip this class if it does not match the current one bound to this name
      next unless parent.const_defined?(basename) && klass = parent.const_get(basename)

      parent.instance_eval { remove_const basename } unless parent == klass
    end
  end
end
