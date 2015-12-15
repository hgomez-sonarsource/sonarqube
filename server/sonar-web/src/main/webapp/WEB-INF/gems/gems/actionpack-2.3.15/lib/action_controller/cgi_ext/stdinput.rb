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

require 'cgi'

module ActionController
  module CgiExt
    # Publicize the CGI's internal input stream so we can lazy-read
    # request.body. Make it writable so we don't have to play $stdin games.
    module Stdinput
      def self.included(base)
        base.class_eval do
          remove_method :stdinput
          attr_accessor :stdinput
        end

        base.alias_method_chain :initialize, :stdinput
      end

      def initialize_with_stdinput(type = nil, stdinput = $stdin)
        @stdinput = stdinput
        @stdinput.set_encoding(Encoding::BINARY) if @stdinput.respond_to?(:set_encoding)
        initialize_without_stdinput(type || 'query')
      end
    end
  end
end
