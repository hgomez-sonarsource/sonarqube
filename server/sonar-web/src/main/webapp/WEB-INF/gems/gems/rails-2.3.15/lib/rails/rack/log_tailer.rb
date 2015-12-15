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

module Rails
  module Rack
    class LogTailer
      EnvironmentLog = "#{File.expand_path(Rails.root)}/log/#{Rails.env}.log"

      def initialize(app, log = nil)
        @app = app

        path = Pathname.new(log || EnvironmentLog).cleanpath
        @cursor = ::File.size(path)
        @last_checked = Time.now.to_f

        @file = ::File.open(path, 'r')
      end

      def call(env)
        response = @app.call(env)
        tail_log
        response
      end

      def tail_log
        @file.seek @cursor

        mod = @file.mtime.to_f
        if mod > @last_checked
          contents = @file.read
          @last_checked = mod
          @cursor += contents.size
          $stdout.print contents
        end
      end
    end
  end
end
