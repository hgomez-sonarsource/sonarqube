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

require 'rack/utils'

module Rails
  module Rack
    class Static
      FILE_METHODS = %w(GET HEAD).freeze

      def initialize(app)
        @app = app
        @file_server = ::Rack::File.new(File.join(RAILS_ROOT, "public"))
      end

      def call(env)
        path        = env['PATH_INFO'].chomp('/')
        method      = env['REQUEST_METHOD']

        if FILE_METHODS.include?(method)
          if file_exist?(path)
            return @file_server.call(env)
          else
            cached_path = directory_exist?(path) ? "#{path}/index" : path
            cached_path += ::ActionController::Base.page_cache_extension

            if file_exist?(cached_path)
              env['PATH_INFO'] = cached_path
              return @file_server.call(env)
            end
          end
        end

        @app.call(env)
      end

      private
        def file_exist?(path)
          full_path = File.join(@file_server.root, ::Rack::Utils.unescape(path))
          File.file?(full_path) && File.readable?(full_path)
        end

        def directory_exist?(path)
          full_path = File.join(@file_server.root, ::Rack::Utils.unescape(path))
          File.directory?(full_path) && File.readable?(full_path)
        end
    end
  end
end
