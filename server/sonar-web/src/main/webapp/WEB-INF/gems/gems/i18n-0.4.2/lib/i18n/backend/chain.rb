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

# encoding: utf-8

module I18n
  module Backend
    # Backend that chains multiple other backends and checks each of them when
    # a translation needs to be looked up. This is useful when you want to use
    # standard translations with a Simple backend but store custom application
    # translations in a database or other backends.
    #
    # To use the Chain backend instantiate it and set it to the I18n module.
    # You can add chained backends through the initializer or backends
    # accessor:
    #
    #   # preserves the existing Simple backend set to I18n.backend
    #   I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new, I18n.backend)
    #
    # The implementation assumes that all backends added to the Chain implement
    # a lookup method with the same API as Simple backend does.
    class Chain
      module Implementation
        include Base

        attr_accessor :backends

        def initialize(*backends)
          self.backends = backends
        end

        def reload!
          backends.each { |backend| backend.reload! }
        end

        def store_translations(locale, data, options = {})
          backends.first.store_translations(locale, data, options = {})
        end

        def available_locales
          backends.map { |backend| backend.available_locales }.flatten.uniq
        end

        def translate(locale, key, default_options = {})
          namespace = nil
          options = default_options.except(:default)

          backends.each do |backend|
            begin
              options = default_options if backend == backends.last
              translation = backend.translate(locale, key, options)
              if namespace_lookup?(translation, options)
                namespace ||= {}
                namespace.merge!(translation)
              elsif !translation.nil?
                return translation
              end
            rescue MissingTranslationData
            end
          end

          return namespace if namespace
          raise(I18n::MissingTranslationData.new(locale, key, options))
        end

        def localize(locale, object, format = :default, options = {})
          backends.each do |backend|
            begin
              result = backend.localize(locale, object, format, options) and return result
            rescue MissingTranslationData
            end
          end
          raise(I18n::MissingTranslationData.new(locale, format, options))
        end

        protected
          def namespace_lookup?(result, options)
            result.is_a?(Hash) && !options.has_key?(:count)
          end
      end

      include Implementation
    end
  end
end
