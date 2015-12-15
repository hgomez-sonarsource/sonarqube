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

module ActionController
  module UploadedFile
    def self.included(base)
      base.class_eval do
        attr_accessor :original_path, :content_type
        alias_method :local_path, :path if method_defined?(:path)
      end
    end

    def self.extended(object)
      object.class_eval do
        attr_accessor :original_path, :content_type
        alias_method :local_path, :path if method_defined?(:path)
      end
    end

    # Take the basename of the upload's original filename.
    # This handles the full Windows paths given by Internet Explorer
    # (and perhaps other broken user agents) without affecting
    # those which give the lone filename.
    # The Windows regexp is adapted from Perl's File::Basename.
    def original_filename
      unless defined? @original_filename
        @original_filename =
          unless original_path.blank?
            if original_path =~ /^(?:.*[:\\\/])?(.*)/m
              $1
            else
              File.basename original_path
            end
          end
      end
      @original_filename
    end
  end

  class UploadedStringIO < StringIO
    include UploadedFile
  end

  class UploadedTempfile < Tempfile
    include UploadedFile
  end
end
