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

module ActiveRecord # :nodoc:
  # Represents exceptions that have propagated up through the JDBC API.
  class JDBCError < ActiveRecordError
    # The vendor code or error number that came from the database
    attr_accessor :errno

    # The full Java SQLException object that was raised
    attr_accessor :sql_exception
  end

  module ConnectionAdapters     # :nodoc:
    # Allows properly re-wrapping/re-defining methods that may already
    # be alias_method_chain'd.
    module ShadowCoreMethods
      def alias_chained_method(meth, feature, target)
        if instance_methods.include?("#{meth}_without_#{feature}")
          alias_method "#{meth}_without_#{feature}".to_sym, target
        else
          alias_method meth, target if meth != target
        end
      end
    end
  end
end
