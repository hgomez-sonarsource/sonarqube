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
  module QuotedPrimaryKeyExtension
    def self.extended(base)
      #       Rails 3 method           Rails 2 method
      meth = [:arel_attributes_values, :attributes_with_quotes].detect do |m|
        base.private_instance_methods.include?(m.to_s)
      end
      pk_hash_key = "self.class.primary_key"
      pk_hash_value = '"?"'
      if meth == :arel_attributes_values
        pk_hash_key = "self.class.arel_table[#{pk_hash_key}]"
        pk_hash_value = "Arel::SqlLiteral.new(#{pk_hash_value})"
      end
      if meth
        base.module_eval <<-PK, __FILE__, __LINE__
          alias :#{meth}_pre_pk :#{meth}
          def #{meth}(include_primary_key = true, *args) #:nodoc:
            aq = #{meth}_pre_pk(include_primary_key, *args)
            if connection.is_a?(ArJdbc::Oracle) || connection.is_a?(ArJdbc::Mimer)
              aq[#{pk_hash_key}] = #{pk_hash_value} if include_primary_key && aq[#{pk_hash_key}].nil?
            end
            aq
          end
        PK
      end
    end
  end
end
