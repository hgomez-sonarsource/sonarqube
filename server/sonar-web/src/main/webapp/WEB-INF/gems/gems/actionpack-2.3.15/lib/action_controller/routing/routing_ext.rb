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

class Object
  def to_param
    to_s
  end
end

class TrueClass
  def to_param
    self
  end
end

class FalseClass
  def to_param
    self
  end
end

class NilClass
  def to_param
    self
  end
end

class Regexp #:nodoc:
  def number_of_captures
    Regexp.new("|#{source}").match('').captures.length
  end

  def multiline?
    options & MULTILINE == MULTILINE
  end

  class << self
    def optionalize(pattern)
      case unoptionalize(pattern)
        when /\A(.|\(.*\))\Z/ then "#{pattern}?"
        else "(?:#{pattern})?"
      end
    end

    def unoptionalize(pattern)
      [/\A\(\?:(.*)\)\?\Z/, /\A(.|\(.*\))\?\Z/].each do |regexp|
        return $1 if regexp =~ pattern
      end
      return pattern
    end
  end
end
