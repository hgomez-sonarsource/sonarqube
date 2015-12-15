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

# I18n translation metadata is useful when you want to access information
# about how a translation was looked up, pluralized or interpolated in
# your application.
#
#   msg = I18n.t(:message, :default => 'Hi!', :scope => :foo)
#   msg.translation_metadata
#   # => { :key => :message, :scope => :foo, :default => 'Hi!' }
#
# If a :count option was passed to #translate it will be set to the metadata.
# Likewise, if any interpolation variables were passed they will also be set.
#
# To enable translation metadata you can simply include the Metadata module
# into the Simple backend class - or whatever other backend you are using:
#
#   I18n::Backend::Simple.send(:include, I18n::Backend::Metadata)
#
module I18n
  module Backend
    module Metadata
      class << self
        def included(base)
          Object.class_eval do
            def translation_metadata
              @translation_metadata ||= {}
            end

            def translation_metadata=(translation_metadata)
              @translation_metadata = translation_metadata
            end
          end unless Object.method_defined?(:translation_metadata)
        end
      end

      def translate(locale, key, options = {})
        metadata = {
          :locale    => locale,
          :key       => key,
          :scope     => options[:scope],
          :default   => options[:default],
          :separator => options[:separator],
          :values    => options.reject { |name, value| Base::RESERVED_KEYS.include?(name) }
        }
        with_metadata(metadata) { super }
      end

      def interpolate(locale, entry, values = {})
        metadata = entry.translation_metadata.merge(:original => entry)
        with_metadata(metadata) { super }
      end

      def pluralize(locale, entry, count)
        with_metadata(:count => count) { super }
      end

      protected

        def with_metadata(metadata, &block)
          result = yield
          result.translation_metadata = result.translation_metadata.merge(metadata) if result
          result
        end

    end
  end
end
