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

# Rack 1.0 does not allow string subclass body. This does not play well with our ActiveSupport::SafeBuffer.
# The next release of Rack will be allowing string subclass body - http://github.com/rack/rack/commit/de668df02802a0335376a81ba709270e43ba9d55
# TODO : Remove this monkey patch after the next release of Rack

module RackLintPatch
  module AllowStringSubclass
    def self.included(base)
      base.send :alias_method, :each, :each_with_hack
    end

    def each_with_hack
      @closed = false

      @body.each { |part|
        assert("Body yielded non-string value #{part.inspect}") {
          part.kind_of?(String)
        }
        yield part
      }

      if @body.respond_to?(:to_path)
        assert("The file identified by body.to_path does not exist") {
          ::File.exist? @body.to_path
        }
      end
    end
  end

  begin
    app = proc {|env| [200, {"Content-Type" => "text/plain", "Content-Length" => "12"}, [Class.new(String).new("Hello World!")]] }
    response = Rack::MockRequest.new(Rack::Lint.new(app)).get('/')
  rescue Rack::Lint::LintError => e
    raise(e) unless e.message =~ /Body yielded non-string value/
    Rack::Lint.send :include, AllowStringSubclass
  end
end
