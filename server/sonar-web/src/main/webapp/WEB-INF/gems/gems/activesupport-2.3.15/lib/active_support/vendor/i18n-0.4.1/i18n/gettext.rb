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
  module Gettext
    PLURAL_SEPARATOR  = "\001"
    CONTEXT_SEPARATOR = "\004"

    autoload :Helpers, 'i18n/gettext/helpers'

    @@plural_keys = { :en => [:one, :other] }

    class << self
      # returns an array of plural keys for the given locale so that we can
      # convert from gettext's integer-index based style
      # TODO move this information to the pluralization module
      def plural_keys(locale)
        @@plural_keys[locale] || @@plural_keys[:en]
      end

      def extract_scope(msgid, separator)
        scope = msgid.to_s.split(separator)
        msgid = scope.pop
        [scope, msgid]
      end
    end
  end
end
