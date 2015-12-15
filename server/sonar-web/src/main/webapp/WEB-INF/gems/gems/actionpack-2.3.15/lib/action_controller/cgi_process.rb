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

require 'action_controller/cgi_ext'

module ActionController #:nodoc:
  class CGIHandler
    module ProperStream
      def each
        while line = gets
          yield line
        end
      end

      def read(*args)
        if args.empty?
          super || ""
        else
          super
        end
      end
    end

    def self.dispatch_cgi(app, cgi, out = $stdout)
      env = cgi.__send__(:env_table)
      env.delete "HTTP_CONTENT_LENGTH"

      cgi.stdinput.extend ProperStream

      env["SCRIPT_NAME"] = "" if env["SCRIPT_NAME"] == "/"

      env.update({
        "rack.version" => [0,1],
        "rack.input" => cgi.stdinput,
        "rack.errors" => $stderr,
        "rack.multithread" => false,
        "rack.multiprocess" => true,
        "rack.run_once" => false,
        "rack.url_scheme" => ["yes", "on", "1"].include?(env["HTTPS"]) ? "https" : "http"
      })

      env["QUERY_STRING"] ||= ""
      env["HTTP_VERSION"] ||= env["SERVER_PROTOCOL"]
      env["REQUEST_PATH"] ||= "/"
      env.delete "PATH_INFO" if env["PATH_INFO"] == ""

      status, headers, body = app.call(env)
      begin
        out.binmode if out.respond_to?(:binmode)
        out.sync = false if out.respond_to?(:sync=)

        headers['Status'] = status.to_s

        if headers.include?('Set-Cookie')
          headers['cookie'] = headers.delete('Set-Cookie').split("\n")
        end

        out.write(cgi.header(headers))

        body.each { |part|
          out.write part
          out.flush if out.respond_to?(:flush)
        }
      ensure
        body.close if body.respond_to?(:close)
      end
    end
  end

  class CgiRequest #:nodoc:
    DEFAULT_SESSION_OPTIONS = {
      :database_manager  => nil,
      :prefix            => "ruby_sess.",
      :session_path      => "/",
      :session_key       => "_session_id",
      :cookie_only       => true,
      :session_http_only => true
    }
  end
end
