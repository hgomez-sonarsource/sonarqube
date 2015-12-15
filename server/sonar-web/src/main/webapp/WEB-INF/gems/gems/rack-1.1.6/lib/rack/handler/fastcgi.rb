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

require 'fcgi'
require 'socket'
require 'rack/content_length'
require 'rack/rewindable_input'

if defined? FCGI::Stream
  class FCGI::Stream
    alias _rack_read_without_buffer read

    def read(n, buffer=nil)
      buf = _rack_read_without_buffer n
      buffer.replace(buf.to_s)  if buffer
      buf
    end
  end
end

module Rack
  module Handler
    class FastCGI
      def self.run(app, options={})
        file = options[:File] and STDIN.reopen(UNIXServer.new(file))
        port = options[:Port] and STDIN.reopen(TCPServer.new(port))
        FCGI.each { |request|
          serve request, app
        }
      end

      def self.serve(request, app)
        app = Rack::ContentLength.new(app)

        env = request.env
        env.delete "HTTP_CONTENT_LENGTH"

        env["SCRIPT_NAME"] = ""  if env["SCRIPT_NAME"] == "/"

        rack_input = RewindableInput.new(request.in)

        env.update({"rack.version" => [1,1],
                     "rack.input" => rack_input,
                     "rack.errors" => request.err,

                     "rack.multithread" => false,
                     "rack.multiprocess" => true,
                     "rack.run_once" => false,

                     "rack.url_scheme" => ["yes", "on", "1"].include?(env["HTTPS"]) ? "https" : "http"
                   })

        env["QUERY_STRING"] ||= ""
        env["HTTP_VERSION"] ||= env["SERVER_PROTOCOL"]
        env["REQUEST_PATH"] ||= "/"
        env.delete "CONTENT_TYPE"  if env["CONTENT_TYPE"] == ""
        env.delete "CONTENT_LENGTH"  if env["CONTENT_LENGTH"] == ""

        begin
          status, headers, body = app.call(env)
          begin
            send_headers request.out, status, headers
            send_body request.out, body
          ensure
            body.close  if body.respond_to? :close
          end
        ensure
          rack_input.close
          request.finish
        end
      end

      def self.send_headers(out, status, headers)
        out.print "Status: #{status}\r\n"
        headers.each { |k, vs|
          vs.split("\n").each { |v|
            out.print "#{k}: #{v}\r\n"
          }
        }
        out.print "\r\n"
        out.flush
      end

      def self.send_body(out, body)
        body.each { |part|
          out.print part
          out.flush
        }
      end
    end
  end
end
