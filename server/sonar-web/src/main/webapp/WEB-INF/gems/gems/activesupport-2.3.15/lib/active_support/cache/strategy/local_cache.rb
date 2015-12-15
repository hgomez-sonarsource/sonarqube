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
    module Strategy
      module LocalCache
        # this allows caching of the fact that there is nothing in the remote cache
        NULL = 'remote_cache_store:null'

        def with_local_cache
          Thread.current[thread_local_key] = MemoryStore.new
          yield
        ensure
          Thread.current[thread_local_key] = nil
        end

        def middleware
          @middleware ||= begin
            klass = Class.new
            klass.class_eval(<<-EOS, __FILE__, __LINE__ + 1)
              def initialize(app)
                @app = app
              end

              def call(env)
                Thread.current[:#{thread_local_key}] = MemoryStore.new
                @app.call(env)
              ensure
                Thread.current[:#{thread_local_key}] = nil
              end
            EOS
            klass
          end
        end

        def read(key, options = nil)
          value = local_cache && local_cache.read(key)
          if value == NULL
            nil
          elsif value.nil?
            value = super
            local_cache.mute { local_cache.write(key, value || NULL) } if local_cache
            value.duplicable? ? value.dup : value
          else
            # forcing the value to be immutable
            value.duplicable? ? value.dup : value
          end
        end

        def write(key, value, options = nil)
          value = value.to_s if respond_to?(:raw?) && raw?(options)
          local_cache.mute { local_cache.write(key, value || NULL) } if local_cache
          super
        end

        def delete(key, options = nil)
          local_cache.mute { local_cache.write(key, NULL) } if local_cache
          super
        end

        def exist(key, options = nil)
          value = local_cache.read(key) if local_cache
          if value == NULL
            false
          elsif value
            true
          else
            super
          end
        end

        def increment(key, amount = 1)
          if value = super
            local_cache.mute { local_cache.write(key, value.to_s) } if local_cache
            value
          else
            nil
          end
        end

        def decrement(key, amount = 1)
          if value = super
            local_cache.mute { local_cache.write(key, value.to_s) } if local_cache
            value
          else
            nil
          end
        end

        def clear
          local_cache.clear if local_cache
          super
        end

        private
          def thread_local_key
            @thread_local_key ||= "#{self.class.name.underscore}_local_cache".gsub("/", "_").to_sym
          end

          def local_cache
            Thread.current[thread_local_key]
          end
      end
    end
  end
end
