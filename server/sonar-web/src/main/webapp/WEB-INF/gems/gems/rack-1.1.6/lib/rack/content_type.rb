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

  # Sets the Content-Type header on responses which don't have one.
  #
  # Builder Usage:
  #   use Rack::ContentType, "text/plain"
  #
  # When no content type argument is provided, "text/html" is assumed.
  class ContentType
    def initialize(app, content_type = "text/html")
      @app, @content_type = app, content_type
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers = Utils::HeaderHash.new(headers)
      headers['Content-Type'] ||= @content_type
      [status, headers, body]
    end
  end
end
