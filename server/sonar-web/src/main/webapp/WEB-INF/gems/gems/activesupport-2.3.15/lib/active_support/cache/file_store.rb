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
    # A cache store implementation which stores everything on the filesystem.
    class FileStore < Store
      attr_reader :cache_path

      def initialize(cache_path)
        @cache_path = cache_path
      end

      def read(name, options = nil)
        super
        File.open(real_file_path(name), 'rb') { |f| Marshal.load(f) } rescue nil
      end

      def write(name, value, options = nil)
        super
        ensure_cache_path(File.dirname(real_file_path(name)))
        File.atomic_write(real_file_path(name), cache_path) { |f| Marshal.dump(value, f) }
        value
      rescue => e
        logger.error "Couldn't create cache directory: #{name} (#{e.message})" if logger
      end

      def delete(name, options = nil)
        super
        File.delete(real_file_path(name))
      rescue SystemCallError => e
        # If there's no cache, then there's nothing to complain about
      end

      def delete_matched(matcher, options = nil)
        super
        search_dir(@cache_path) do |f|
          if f =~ matcher
            begin
              File.delete(f)
            rescue SystemCallError => e
              # If there's no cache, then there's nothing to complain about
            end
          end
        end
      end

      def exist?(name, options = nil)
        super
        File.exist?(real_file_path(name))
      end

      private
        def real_file_path(name)
          '%s/%s.cache' % [@cache_path, name.gsub('?', '.').gsub(':', '.')]
        end

        def ensure_cache_path(path)
          FileUtils.makedirs(path) unless File.exist?(path)
        end

        def search_dir(dir, &callback)
          Dir.foreach(dir) do |d|
            next if d == "." || d == ".."
            name = File.join(dir, d)
            if File.directory?(name)
              search_dir(name, &callback)
            else
              callback.call name
            end
          end
        end
    end
  end
end
