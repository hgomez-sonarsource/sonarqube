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

require 'lsapi'
require 'rack/content_length'
require 'rack/rewindable_input'

module Rack
  module Handler
    class LSWS
      def self.run(app, options=nil)
        while LSAPI.accept != nil
          serve app
        end
      end
      def self.serve(app)
        app = Rack::ContentLength.new(app)

        env = ENV.to_hash
        env.delete "HTTP_CONTENT_LENGTH"
        env["SCRIPT_NAME"] = "" if env["SCRIPT_NAME"] == "/"

        rack_input = RewindableInput.new($stdin.read.to_s)

        env.update(
          "rack.version" => [1,1],
          "rack.input" => rack_input,
          "rack.errors" => $stderr,
          "rack.multithread" => false,
          "rack.multiprocess" => true,
          "rack.run_once" => false,
          "rack.url_scheme" => ["yes", "on", "1"].include?(ENV["HTTPS"]) ? "https" : "http"
        )

        env["QUERY_STRING"] ||= ""
        env["HTTP_VERSION"] ||= env["SERVER_PROTOCOL"]
        env["REQUEST_PATH"] ||= "/"
        status, headers, body = app.call(env)
        begin
          send_headers status, headers
          send_body body
        ensure
          body.close if body.respond_to? :close
        end
      ensure
        rack_input.close
      end
      def self.send_headers(status, headers)
        print "Status: #{status}\r\n"
        headers.each { |k, vs|
          vs.split("\n").each { |v|
            print "#{k}: #{v}\r\n"
          }
        }
        print "\r\n"
        STDOUT.flush
      end
      def self.send_body(body)
        body.each { |part|
          print part
          STDOUT.flush
        }
      end
    end
  end
end
