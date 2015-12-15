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

# Simple Locale tag implementation that computes subtags by simply splitting
# the locale tag at '-' occurences.
module I18n
  module Locale
    module Tag
      class Simple
        class << self
          def tag(tag)
            new(tag)
          end
        end

        include Parents

        attr_reader :tag

        def initialize(*tag)
          @tag = tag.join('-').to_sym
        end

        def subtags
          @subtags = tag.to_s.split('-').map { |subtag| subtag.to_s }
        end

        def to_sym
          tag
        end

        def to_s
          tag.to_s
        end

        def to_a
          subtags
        end
      end
    end
  end
end
