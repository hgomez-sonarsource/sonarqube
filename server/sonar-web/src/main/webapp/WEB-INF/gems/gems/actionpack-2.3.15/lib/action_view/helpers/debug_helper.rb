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

module ActionView
  module Helpers
    # Provides a set of methods for making it easier to debug Rails objects.
    module DebugHelper
      # Returns a YAML representation of +object+ wrapped with <pre> and </pre>.
      # If the object cannot be converted to YAML using +to_yaml+, +inspect+ will be called instead.
      # Useful for inspecting an object at the time of rendering.
      #
      # ==== Example
      #
      #   @user = User.new({ :username => 'testing', :password => 'xyz', :age => 42}) %>
      #   debug(@user)
      #   # =>
      #   <pre class='debug_dump'>--- !ruby/object:User
      #   attributes:
      #   &nbsp; updated_at:
      #   &nbsp; username: testing
      #
      #   &nbsp; age: 42
      #   &nbsp; password: xyz
      #   &nbsp; created_at:
      #   attributes_cache: {}
      #
      #   new_record: true
      #   </pre>

      def debug(object)
        begin
          Marshal::dump(object)
          "<pre class='debug_dump'>#{h(object.to_yaml).gsub("  ", "&nbsp; ")}</pre>".html_safe
        rescue Exception => e  # errors from Marshal or YAML
          # Object couldn't be dumped, perhaps because of singleton methods -- this is the fallback
          "<code class='debug_dump'>#{h(object.inspect)}</code>".html_safe
        end
      end
    end
  end
end
