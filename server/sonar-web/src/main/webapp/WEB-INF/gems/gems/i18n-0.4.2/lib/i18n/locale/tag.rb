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
  module Locale
    module Tag
      autoload :Parents, 'i18n/locale/tag/parents'
      autoload :Rfc4646, 'i18n/locale/tag/rfc4646'
      autoload :Simple,  'i18n/locale/tag/simple'

      class << self
        # Returns the current locale tag implementation. Defaults to +I18n::Locale::Tag::Simple+.
        def implementation
          @@implementation ||= Simple
        end

        # Sets the current locale tag implementation. Use this to set a different locale tag implementation.
        def implementation=(implementation)
          @@implementation = implementation
        end

        # Factory method for locale tags. Delegates to the current locale tag implementation.
        def tag(tag)
          implementation.tag(tag)
        end
      end
    end
  end
end
