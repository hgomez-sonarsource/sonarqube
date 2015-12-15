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

module Rack

  # Middleware that applies chunked transfer encoding to response bodies
  # when the response does not include a Content-Length header.
  class Chunked
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers = HeaderHash.new(headers)

      if env['HTTP_VERSION'] == 'HTTP/1.0' ||
         STATUS_WITH_NO_ENTITY_BODY.include?(status) ||
         headers['Content-Length'] ||
         headers['Transfer-Encoding']
        [status, headers, body]
      else
        dup.chunk(status, headers, body)
      end
    end

    def chunk(status, headers, body)
      @body = body
      headers.delete('Content-Length')
      headers['Transfer-Encoding'] = 'chunked'
      [status, headers, self]
    end

    def each
      term = "\r\n"
      @body.each do |chunk|
        size = bytesize(chunk)
        next if size == 0
        yield [size.to_s(16), term, chunk, term].join
      end
      yield ["0", term, "", term].join
    end

    def close
      @body.close if @body.respond_to?(:close)
    end
  end
end
