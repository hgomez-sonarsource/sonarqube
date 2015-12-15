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

module Kernel
  unless respond_to?(:debugger)
    # Starts a debugging session if ruby-debug has been loaded (call script/server --debugger to do load it).
    def debugger
      message = "\n***** Debugger requested, but was not available: Start server with --debugger to enable *****\n"
      defined?(Rails) ? Rails.logger.info(message) : $stderr.puts(message)
    end
  end

  undef :breakpoint if respond_to?(:breakpoint)
  def breakpoint
    message = "\n***** The 'breakpoint' command has been renamed 'debugger' -- please change *****\n"
    defined?(Rails) ? Rails.logger.info(message) : $stderr.puts(message)
    debugger
  end
end
