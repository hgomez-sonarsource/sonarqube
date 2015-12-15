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
require 'i18n/gettext'

module I18n
  module Gettext
    # Implements classical Gettext style accessors. To use this include the
    # module to the global namespace or wherever you want to use it.
    #
    #   include I18n::Helpers::Gettext
    module Helpers
      def gettext(msgid, options = {})
        I18n.t(msgid, { :default => msgid, :separator => '|' }.merge(options))
      end
      alias _ gettext

      def sgettext(msgid, separator = '|')
        scope, msgid = I18n::Gettext.extract_scope(msgid, separator)
        I18n.t(msgid, :scope => scope, :default => msgid, :separator => separator)
      end
      alias s_ sgettext

      def pgettext(msgctxt, msgid)
        separator = I18n::Gettext::CONTEXT_SEPARATOR
        sgettext([msgctxt, msgid].join(separator), separator)
      end
      alias p_ pgettext

      def ngettext(msgid, msgid_plural, n = 1)
        nsgettext(msgid, msgid_plural, n)
      end
      alias n_ ngettext

      # Method signatures:
      #   nsgettext('Fruits|apple', 'apples', 2)
      #   nsgettext(['Fruits|apple', 'apples'], 2)
      def nsgettext(msgid, msgid_plural, n = 1, separator = '|')
        if msgid.is_a?(Array)
          msgid, msgid_plural, n, separator = msgid[0], msgid[1], msgid_plural, n
          separator = '|' unless separator.is_a?(::String)
        end

        scope, msgid = I18n::Gettext.extract_scope(msgid, separator)
        default = { :one => msgid, :other => msgid_plural }
        I18n.t(msgid, :default => default, :count => n, :scope => scope, :separator => separator)
      end
      alias ns_ nsgettext

      # Method signatures:
      #   npgettext('Fruits', 'apple', 'apples', 2)
      #   npgettext('Fruits', ['apple', 'apples'], 2)
      def npgettext(msgctxt, msgid, msgid_plural, n = 1)
        separator = I18n::Gettext::CONTEXT_SEPARATOR

        if msgid.is_a?(Array)
          msgid_plural, msgid, n = msgid[1], [msgctxt, msgid[0]].join(separator), msgid_plural
        else
          msgid = [msgctxt, msgid].join(separator)
        end

        nsgettext(msgid, msgid_plural, n, separator)
      end
      alias np_ npgettext
    end
  end
end
