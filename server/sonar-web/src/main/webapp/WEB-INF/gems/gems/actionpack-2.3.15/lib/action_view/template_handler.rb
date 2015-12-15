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

# Legacy TemplateHandler stub
module ActionView
  module TemplateHandlers #:nodoc:
    module Compilable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def call(template)
          new.compile(template)
        end
      end

      def compile(template)
         raise "Need to implement #{self.class.name}#compile(template)"
       end
    end
  end

  class TemplateHandler
    def self.call(template)
      "#{name}.new(self).render(template, local_assigns)"
    end

    def initialize(view = nil)
      @view = view
    end

    def render(template, local_assigns)
      raise "Need to implement #{self.class.name}#render(template, local_assigns)"
    end
  end
end
