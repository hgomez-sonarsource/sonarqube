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

require 'zlib'
require 'stringio'

module ActiveSupport
  # A convenient wrapper for the zlib standard library that allows compression/decompression of strings with gzip.
  module Gzip
    class Stream < StringIO
      def close; rewind; end
    end

    # Decompresses a gzipped string.
    def self.decompress(source)
      Zlib::GzipReader.new(StringIO.new(source)).read
    end

    # Compresses a string using gzip.
    def self.compress(source)
      output = Stream.new
      gz = Zlib::GzipWriter.new(output)
      gz.write(source)
      gz.close
      output.string
    end
  end
end