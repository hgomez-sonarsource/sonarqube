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

require 'active_support/core_ext/array/wrapper'

class Hash
  # Returns a JSON string representing the hash.
  #
  # Without any +options+, the returned JSON string will include all
  # the hash keys. For example:
  #
  #   { :name => "Konata Izumi", 'age' => 16, 1 => 2 }.to_json
  #   # => {"name": "Konata Izumi", "1": 2, "age": 16}
  #
  # The keys in the JSON string are unordered due to the nature of hashes.
  #
  # The <tt>:only</tt> and <tt>:except</tt> options can be used to limit the
  # attributes included, and will accept 1 or more hash keys to include/exclude.
  #
  #   { :name => "Konata Izumi", 'age' => 16, 1 => 2 }.to_json(:only => [:name, 'age'])
  #   # => {"name": "Konata Izumi", "age": 16}
  #
  #   { :name => "Konata Izumi", 'age' => 16, 1 => 2 }.to_json(:except => 1)
  #   # => {"name": "Konata Izumi", "age": 16}
  #
  # The +options+ also filter down to any hash values. This is particularly
  # useful for converting hashes containing ActiveRecord objects or any object
  # that responds to options in their <tt>to_json</tt> method. For example:
  #
  #   users = User.find(:all)
  #   { :users => users, :count => users.size }.to_json(:include => :posts)
  #
  # would pass the <tt>:include => :posts</tt> option to <tt>users</tt>,
  # allowing the posts association in the User model to be converted to JSON
  # as well.
  def to_json(options = nil) #:nodoc:
    hash = as_json(options)

    result = '{'
    result << hash.map do |key, value|
      "#{ActiveSupport::JSON.encode(key.to_s)}:#{ActiveSupport::JSON.encode(value, options)}"
    end * ','
    result << '}'
  end

  def as_json(options = nil) #:nodoc:
    if options
      if attrs = options[:except]
        except(*Array.wrap(attrs))
      elsif attrs = options[:only]
        slice(*Array.wrap(attrs))
      else
        self
      end
    else
      self
    end
  end
end
