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
  # = XmlMini
  #
  # To use the much faster libxml parser:
  #   gem 'libxml-ruby', '=0.9.7'
  #   XmlMini.backend = 'LibXML'
  module XmlMini
    extend self

    attr_reader :backend
    delegate :parse, :to => :backend

    def backend=(name)
      if name.is_a?(Module)
        @backend = name
      else
        require "active_support/xml_mini/#{name.to_s.downcase}.rb"
        @backend = ActiveSupport.const_get("XmlMini_#{name}")
      end
    end

    def with_backend(name)
      old_backend, self.backend = backend, name
      yield
    ensure
      self.backend = old_backend
    end
  end

  XmlMini.backend = 'REXML'
end
