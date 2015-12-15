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

# This file contains implementations of rails custom objects for
# serialisation/deserialisation.

unless Object.const_defined?(:JSON) and ::JSON.const_defined?(:JSON_LOADED) and
  ::JSON::JSON_LOADED
  require 'json'
end

class Object
  def self.json_create(object)
    obj = new
    for key, value in object
      next if key == JSON.create_id
      instance_variable_set "@#{key}", value
    end
    obj
  end

  def to_json(*a)
    result = {
      JSON.create_id => self.class.name
    }
    instance_variables.inject(result) do |r, name|
      r[name[1..-1]] = instance_variable_get name
      r
    end
    result.to_json(*a)
  end
end

class Symbol
  def to_json(*a)
    to_s.to_json(*a)
  end
end

module Enumerable
  def to_json(*a)
    to_a.to_json(*a)
  end
end

# class Regexp
#   def to_json(*)
#     inspect
#   end
# end
#
# The above rails definition has some problems:
#
# 1. { 'foo' => /bar/ }.to_json # => "{foo: /bar/}"
#    This isn't valid JSON, because the regular expression syntax is not
#    defined in RFC 4627. (And unquoted strings are disallowed there, too.)
#    Though it is valid Javascript.
#
# 2. { 'foo' => /bar/mix }.to_json # => "{foo: /bar/mix}"
#    This isn't even valid Javascript.

