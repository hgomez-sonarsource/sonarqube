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

# This module is intended to be mixed into the ActiveRecord backend to allow
# storing Ruby Procs as translation values in the database.
#
#   I18n.backend = I18n::Backend::ActiveRecord.new
#   I18n::Backend::ActiveRecord::Translation.send(:include, I18n::Backend::ActiveRecord::StoreProcs)
#
# The StoreProcs module requires the ParseTree and ruby2ruby gems and therefor
# was extracted from the original backend.
#
# ParseTree is not compatible with Ruby 1.9.

begin
  require 'ruby2ruby'
  require 'parse_tree'
  require 'parse_tree_extensions'
rescue LoadError => e
  puts "can't use StoreProcs because: #{e.message}"
end

module I18n
  module Backend
    class ActiveRecord
      module StoreProcs
        def value=(v)
          case v
          when Proc
            write_attribute(:value, v.to_ruby)
            write_attribute(:is_proc, true)
          else
            write_attribute(:value, v)
          end
        end

        Translation.send(:include, self) if method(:to_s).respond_to?(:to_ruby)
      end
    end
  end
end