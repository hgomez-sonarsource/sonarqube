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

begin
  require 'active_support'
rescue LoadError
  activesupport_path = "#{File.dirname(__FILE__)}/../../activesupport/lib"
  if File.directory?(activesupport_path)
    $:.unshift activesupport_path
    require 'active_support'
  end
end

module ActiveRecord
  # TODO: Review explicit loads to see if they will automatically be handled by the initilizer.
  def self.load_all!
    [Base, DynamicFinderMatch, ConnectionAdapters::AbstractAdapter]
  end

  autoload :VERSION, 'active_record/version'

  autoload :ActiveRecordError, 'active_record/base'
  autoload :ConnectionNotEstablished, 'active_record/base'

  autoload :Aggregations, 'active_record/aggregations'
  autoload :AssociationPreload, 'active_record/association_preload'
  autoload :Associations, 'active_record/associations'
  autoload :AttributeMethods, 'active_record/attribute_methods'
  autoload :AutosaveAssociation, 'active_record/autosave_association'
  autoload :Base, 'active_record/base'
  autoload :Batches, 'active_record/batches'
  autoload :Calculations, 'active_record/calculations'
  autoload :Callbacks, 'active_record/callbacks'
  autoload :Dirty, 'active_record/dirty'
  autoload :DynamicFinderMatch, 'active_record/dynamic_finder_match'
  autoload :DynamicScopeMatch, 'active_record/dynamic_scope_match'
  autoload :Migration, 'active_record/migration'
  autoload :Migrator, 'active_record/migration'
  autoload :NamedScope, 'active_record/named_scope'
  autoload :NestedAttributes, 'active_record/nested_attributes'
  autoload :Observing, 'active_record/observer'
  autoload :QueryCache, 'active_record/query_cache'
  autoload :Reflection, 'active_record/reflection'
  autoload :Schema, 'active_record/schema'
  autoload :SchemaDumper, 'active_record/schema_dumper'
  autoload :Serialization, 'active_record/serialization'
  autoload :SessionStore, 'active_record/session_store'
  autoload :TestCase, 'active_record/test_case'
  autoload :Timestamp, 'active_record/timestamp'
  autoload :Transactions, 'active_record/transactions'
  autoload :Validations, 'active_record/validations'

  module Locking
    autoload :Optimistic, 'active_record/locking/optimistic'
    autoload :Pessimistic, 'active_record/locking/pessimistic'
  end

  module ConnectionAdapters
    autoload :AbstractAdapter, 'active_record/connection_adapters/abstract_adapter'
  end
end

I18n.load_path << File.dirname(__FILE__) + '/active_record/locale/en.yml'
