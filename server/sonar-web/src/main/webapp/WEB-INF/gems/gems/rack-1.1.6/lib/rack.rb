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

# The Rack main module, serving as a namespace for all core Rack
# modules and classes.
#
# All modules meant for use in your application are <tt>autoload</tt>ed here,
# so it should be enough just to <tt>require rack.rb</tt> in your code.

module Rack
  # The Rack protocol version number implemented.
  VERSION = [1,1]

  # Return the Rack protocol version as a dotted string.
  def self.version
    VERSION.join(".")
  end

  # Return the Rack release as a dotted string.
  def self.release
    "1.1.6"
  end

  autoload :Builder, "rack/builder"
  autoload :Cascade, "rack/cascade"
  autoload :Chunked, "rack/chunked"
  autoload :CommonLogger, "rack/commonlogger"
  autoload :ConditionalGet, "rack/conditionalget"
  autoload :Config, "rack/config"
  autoload :ContentLength, "rack/content_length"
  autoload :ContentType, "rack/content_type"
  autoload :ETag, "rack/etag"
  autoload :File, "rack/file"
  autoload :Deflater, "rack/deflater"
  autoload :Directory, "rack/directory"
  autoload :ForwardRequest, "rack/recursive"
  autoload :Handler, "rack/handler"
  autoload :Head, "rack/head"
  autoload :Lint, "rack/lint"
  autoload :Lock, "rack/lock"
  autoload :Logger, "rack/logger"
  autoload :MethodOverride, "rack/methodoverride"
  autoload :Mime, "rack/mime"
  autoload :NullLogger, "rack/nulllogger"
  autoload :Recursive, "rack/recursive"
  autoload :Reloader, "rack/reloader"
  autoload :Runtime, "rack/runtime"
  autoload :Sendfile, "rack/sendfile"
  autoload :Server, "rack/server"
  autoload :ShowExceptions, "rack/showexceptions"
  autoload :ShowStatus, "rack/showstatus"
  autoload :Static, "rack/static"
  autoload :URLMap, "rack/urlmap"
  autoload :Utils, "rack/utils"

  autoload :MockRequest, "rack/mock"
  autoload :MockResponse, "rack/mock"

  autoload :Request, "rack/request"
  autoload :Response, "rack/response"

  module Auth
    autoload :Basic, "rack/auth/basic"
    autoload :AbstractRequest, "rack/auth/abstract/request"
    autoload :AbstractHandler, "rack/auth/abstract/handler"
    module Digest
      autoload :MD5, "rack/auth/digest/md5"
      autoload :Nonce, "rack/auth/digest/nonce"
      autoload :Params, "rack/auth/digest/params"
      autoload :Request, "rack/auth/digest/request"
    end

    # Not all of the following schemes are "standards", but they are used often.
    @schemes = %w[basic digest bearer mac token oauth oauth2]

    def self.add_scheme scheme
      @schemes << scheme
      @schemes.uniq!
    end

    def self.schemes
      @schemes.dup
    end
  end

  module Session
    autoload :Cookie, "rack/session/cookie"
    autoload :Pool, "rack/session/pool"
    autoload :Memcache, "rack/session/memcache"
  end

  # *Adapters* connect Rack with third party web frameworks.
  #
  # Rack includes an adapter for Camping, see README for other
  # frameworks supporting Rack in their code bases.
  #
  # Refer to the submodules for framework-specific calling details.

  module Adapter
    autoload :Camping, "rack/adapter/camping"
  end
end
