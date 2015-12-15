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

# I18n locale fallbacks are useful when you want your application to use
# translations from other locales when translations for the current locale are
# missing. E.g. you might want to use :en translations when translations in
# your applications main locale :de are missing.
#
# To enable locale specific pluralizations you can simply include the
# Pluralization module to the Simple backend - or whatever other backend you
# are using.
#
#   I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
#
# You also need to make sure to provide pluralization algorithms to the
# backend, i.e. include them to your I18n.load_path accordingly.
module I18n
  module Backend
    module Pluralization
      # Overwrites the Base backend translate method so that it will check the
      # translation meta data space (:i18n) for a locale specific pluralization
      # rule and use it to pluralize the given entry. I.e. the library expects
      # pluralization rules to be stored at I18n.t(:'i18n.plural.rule')
      #
      # Pluralization rules are expected to respond to #call(entry, count) and
      # return a pluralization key. Valid keys depend on the translation data
      # hash (entry) but it is generally recommended to follow CLDR's style,
      # i.e., return one of the keys :zero, :one, :few, :many, :other.
      #
      # The :zero key is always picked directly when count equals 0 AND the
      # translation data has the key :zero. This way translators are free to
      # either pick a special :zero translation even for languages where the
      # pluralizer does not return a :zero key.
      def pluralize(locale, entry, count)
        return entry unless entry.is_a?(Hash) and count

        pluralizer = pluralizer(locale)
        if pluralizer.respond_to?(:call)
          key = count == 0 && entry.has_key?(:zero) ? :zero : pluralizer.call(count)
          raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
          entry[key]
        else
          super
        end
      end

      protected

        def pluralizers
          @pluralizers ||= {}
        end

        def pluralizer(locale)
          pluralizers[locale] ||= I18n.t(:'i18n.plural.rule', :locale => locale, :resolve => false)
        end
    end
  end
end
