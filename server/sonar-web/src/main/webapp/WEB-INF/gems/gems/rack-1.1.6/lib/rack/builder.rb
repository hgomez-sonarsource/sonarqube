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

module Rack
  # Rack::Builder implements a small DSL to iteratively construct Rack
  # applications.
  #
  # Example:
  #
  #  app = Rack::Builder.new {
  #    use Rack::CommonLogger
  #    use Rack::ShowExceptions
  #    map "/lobster" do
  #      use Rack::Lint
  #      run Rack::Lobster.new
  #    end
  #  }
  #
  # Or
  #
  #  app = Rack::Builder.app do
  #    use Rack::CommonLogger
  #    lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'OK'] }
  #  end
  #
  # +use+ adds a middleware to the stack, +run+ dispatches to an application.
  # You can use +map+ to construct a Rack::URLMap in a convenient way.

  class Builder
    def self.parse_file(config, opts = Server::Options.new)
      options = {}
      if config =~ /\.ru$/
        cfgfile = ::File.read(config)
        if cfgfile[/^#\\(.*)/] && opts
          options = opts.parse! $1.split(/\s+/)
        end
        cfgfile.sub!(/^__END__\n.*/, '')
        app = eval "Rack::Builder.new {( " + cfgfile + "\n )}.to_app",
          TOPLEVEL_BINDING, config
      else
        require config
        app = Object.const_get(::File.basename(config, '.rb').capitalize)
      end
      return app, options
    end

    def initialize(&block)
      @ins = []
      instance_eval(&block) if block_given?
    end

    def self.app(&block)
      self.new(&block).to_app
    end

    def use(middleware, *args, &block)
      @ins << lambda { |app| middleware.new(app, *args, &block) }
    end

    def run(app)
      @ins << app #lambda { |nothing| app }
    end

    def map(path, &block)
      if @ins.last.kind_of? Hash
        @ins.last[path] = self.class.new(&block).to_app
      else
        @ins << {}
        map(path, &block)
      end
    end

    def to_app
      @ins[-1] = Rack::URLMap.new(@ins.last)  if Hash === @ins.last
      inner_app = @ins.last
      @ins[0...-1].reverse.inject(inner_app) { |a, e| e.call(a) }
    end

    def call(env)
      to_app.call(env)
    end
  end
end
