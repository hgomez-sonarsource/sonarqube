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

require 'rack/auth/abstract/request'
require 'rack/auth/digest/params'
require 'rack/auth/digest/nonce'

module Rack
  module Auth
    module Digest
      class Request < Auth::AbstractRequest

        def method
          @env['rack.methodoverride.original_method'] || @env['REQUEST_METHOD']
        end

        def digest?
          :digest == scheme
        end

        def correct_uri?
          (@env['SCRIPT_NAME'].to_s + @env['PATH_INFO'].to_s) == uri
        end

        def nonce
          @nonce ||= Nonce.parse(params['nonce'])
        end

        def params
          @params ||= Params.parse(parts.last)
        end

        def method_missing(sym)
          if params.has_key? key = sym.to_s
            return params[key]
          end
          super
        end

      end
    end
  end
end
