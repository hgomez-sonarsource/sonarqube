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

module ActiveSupport
  def self.load_all!
    [Dependencies, Deprecation, Gzip, MessageVerifier, Multibyte, SecureRandom, TimeWithZone]
  end

  autoload :BacktraceCleaner, 'active_support/backtrace_cleaner'
  autoload :Base64, 'active_support/base64'
  autoload :BasicObject, 'active_support/basic_object'
  autoload :BufferedLogger, 'active_support/buffered_logger'
  autoload :Cache, 'active_support/cache'
  autoload :Callbacks, 'active_support/callbacks'
  autoload :Deprecation, 'active_support/deprecation'
  autoload :Duration, 'active_support/duration'
  autoload :Gzip, 'active_support/gzip'
  autoload :Inflector, 'active_support/inflector'
  autoload :Memoizable, 'active_support/memoizable'
  autoload :MessageEncryptor, 'active_support/message_encryptor'
  autoload :MessageVerifier, 'active_support/message_verifier'
  autoload :Multibyte, 'active_support/multibyte'
  autoload :OptionMerger, 'active_support/option_merger'
  autoload :OrderedHash, 'active_support/ordered_hash'
  autoload :OrderedOptions, 'active_support/ordered_options'
  autoload :Rescuable, 'active_support/rescuable'
  autoload :SafeBuffer, 'active_support/core_ext/string/output_safety'
  autoload :SecureRandom, 'active_support/secure_random'
  autoload :StringInquirer, 'active_support/string_inquirer'
  autoload :TimeWithZone, 'active_support/time_with_zone'
  autoload :TimeZone, 'active_support/values/time_zone'
  autoload :XmlMini, 'active_support/xml_mini'
end

require 'active_support/vendor'
require 'active_support/core_ext'
require 'active_support/dependencies'
require 'active_support/json'

I18n.load_path << "#{File.dirname(__FILE__)}/active_support/locale/en.yml"
