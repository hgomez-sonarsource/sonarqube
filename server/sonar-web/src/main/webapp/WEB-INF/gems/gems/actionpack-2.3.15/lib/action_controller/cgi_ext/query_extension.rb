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

require 'cgi'

class CGI #:nodoc:
  module QueryExtension
    # Remove the old initialize_query method before redefining it.
    remove_method :initialize_query

    # Neuter CGI parameter parsing.
    def initialize_query
      # Fix some strange request environments.
      env_table['REQUEST_METHOD'] ||= 'GET'

      # POST assumes missing Content-Type is application/x-www-form-urlencoded.
      if env_table['CONTENT_TYPE'].blank? && env_table['REQUEST_METHOD'] == 'POST'
        env_table['CONTENT_TYPE'] = 'application/x-www-form-urlencoded'
      end

      @cookies = CGI::Cookie::parse(env_table['HTTP_COOKIE'] || env_table['COOKIE'])
      @params = {}
    end
  end
end
