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

if RUBY_VERSION < "1.9"
  module Process
    def self.daemon(nochdir = nil, noclose = nil)
      exit if fork                     # Parent exits, child continues.
      Process.setsid                   # Become session leader.
      exit if fork                     # Zap session leader. See [1].

      unless nochdir
        Dir.chdir "/"                  # Release old working directory.
      end

      File.umask 0000                  # Ensure sensible umask. Adjust as needed.

      unless noclose
        STDIN.reopen "/dev/null"       # Free file descriptors and
        STDOUT.reopen "/dev/null", "a" # point them somewhere sensible.
        STDERR.reopen '/dev/null', 'a'
      end

      trap("TERM") { exit }

      return 0
    end
  end
end
