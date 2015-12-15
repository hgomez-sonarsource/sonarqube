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

module I18n
  module Backend
    autoload :ActiveRecord,          'i18n/backend/active_record'
    autoload :Base,                  'i18n/backend/base'
    autoload :InterpolationCompiler, 'i18n/backend/interpolation_compiler'
    autoload :Cache,                 'i18n/backend/cache'
    autoload :Cascade,               'i18n/backend/cascade'
    autoload :Chain,                 'i18n/backend/chain'
    autoload :Cldr,                  'i18n/backend/cldr'
    autoload :Fallbacks,             'i18n/backend/fallbacks'
    autoload :Flatten,               'i18n/backend/flatten'
    autoload :Gettext,               'i18n/backend/gettext'
    autoload :KeyValue,              'i18n/backend/key_value'
    autoload :Memoize,               'i18n/backend/memoize'
    autoload :Metadata,              'i18n/backend/metadata'
    autoload :Pluralization,         'i18n/backend/pluralization'
    autoload :Simple,                'i18n/backend/simple'
    autoload :Transliterator,        'i18n/backend/transliterator'
  end
end
