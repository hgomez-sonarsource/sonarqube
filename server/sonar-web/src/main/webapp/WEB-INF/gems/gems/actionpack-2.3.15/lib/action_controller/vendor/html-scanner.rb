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

$LOAD_PATH << "#{File.dirname(__FILE__)}/html-scanner"

module HTML
  autoload :CDATA, 'html/node'
  autoload :Document, 'html/document'
  autoload :FullSanitizer, 'html/sanitizer'
  autoload :LinkSanitizer, 'html/sanitizer'
  autoload :Node, 'html/node'
  autoload :Sanitizer, 'html/sanitizer'
  autoload :Selector, 'html/selector'
  autoload :Tag, 'html/node'
  autoload :Text, 'html/node'
  autoload :Tokenizer, 'html/tokenizer'
  autoload :Version, 'html/version'
  autoload :WhiteListSanitizer, 'html/sanitizer'
end
