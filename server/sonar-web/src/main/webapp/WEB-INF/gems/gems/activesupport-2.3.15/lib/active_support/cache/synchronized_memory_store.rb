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

module ActiveSupport
  module Cache
    # Like MemoryStore, but thread-safe.
    class SynchronizedMemoryStore < MemoryStore
      def initialize
        super
        @guard = Monitor.new
      end

      def fetch(key, options = {})
        @guard.synchronize { super }
      end

      def read(name, options = nil)
        @guard.synchronize { super }
      end

      def write(name, value, options = nil)
        @guard.synchronize { super }
      end

      def delete(name, options = nil)
        @guard.synchronize { super }
      end

      def delete_matched(matcher, options = nil)
        @guard.synchronize { super }
      end

      def exist?(name,options = nil)
        @guard.synchronize { super }
      end

      def increment(key, amount = 1)
        @guard.synchronize { super }
      end

      def decrement(key, amount = 1)
        @guard.synchronize { super }
      end

      def clear
        @guard.synchronize { super }
      end
    end
  end
end
