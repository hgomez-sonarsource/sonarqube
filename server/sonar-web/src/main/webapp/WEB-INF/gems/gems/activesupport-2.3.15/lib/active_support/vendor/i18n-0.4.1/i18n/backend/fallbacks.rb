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
# To enable locale fallbacks you can simply include the Fallbacks module to
# the Simple backend - or whatever other backend you are using:
#
#   I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
module I18n
  @@fallbacks = nil

  class << self
    # Returns the current fallbacks implementation. Defaults to +I18n::Locale::Fallbacks+.
    def fallbacks
      @@fallbacks ||= I18n::Locale::Fallbacks.new
    end

    # Sets the current fallbacks implementation. Use this to set a different fallbacks implementation.
    def fallbacks=(fallbacks)
      @@fallbacks = fallbacks
    end
  end

  module Backend
    module Fallbacks
      # Overwrites the Base backend translate method so that it will try each
      # locale given by I18n.fallbacks for the given locale. E.g. for the
      # locale :"de-DE" it might try the locales :"de-DE", :de and :en
      # (depends on the fallbacks implementation) until it finds a result with
      # the given options. If it does not find any result for any of the
      # locales it will then raise a MissingTranslationData exception as
      # usual.
      #
      # The default option takes precedence over fallback locales
      # only when it's not a String. When default contains String it
      # is evaluated after fallback locales.
      def translate(locale, key, options = {})
        default = extract_string_default!(options) if options[:default]

        I18n.fallbacks[locale].each do |fallback|
          begin
            result = super(fallback, key, options)
            return result unless result.nil?
          rescue I18n::MissingTranslationData
          end
        end

        return super(locale, nil, options.merge(:default => default)) if default
        raise(I18n::MissingTranslationData.new(locale, key, options))
      end

      def extract_string_default!(options)
        defaults = Array(options[:default])
        if index = find_first_string_default(defaults)
          options[:default] = defaults[0, index]
          defaults[index]
        end
      end

      def find_first_string_default(defaults)
        defaults.each_index { |ix| return ix if String === defaults[ix] }
        nil
      end
    end
  end
end
