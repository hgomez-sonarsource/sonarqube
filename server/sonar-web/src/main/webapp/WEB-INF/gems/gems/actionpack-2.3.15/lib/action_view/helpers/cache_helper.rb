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
    # This helper to exposes a method for caching of view fragments.
    # See ActionController::Caching::Fragments for usage instructions.
    module CacheHelper
      # A method for caching fragments of a view rather than an entire
      # action or page.  This technique is useful caching pieces like
      # menus, lists of news topics, static HTML fragments, and so on.
      # This method takes a block that contains the content you wish
      # to cache.  See ActionController::Caching::Fragments for more
      # information.
      #
      # ==== Examples
      # If you wanted to cache a navigation menu, you could do the
      # following.
      #
      #   <% cache do %>
      #     <%= render :partial => "menu" %>
      #   <% end %>
      #
      # You can also cache static content...
      #
      #   <% cache do %>
      #      <p>Hello users!  Welcome to our website!</p>
      #   <% end %>
      #
      # ...and static content mixed with RHTML content.
      #
      #    <% cache do %>
      #      Topics:
      #      <%= render :partial => "topics", :collection => @topic_list %>
      #      <i>Topics listed alphabetically</i>
      #    <% end %>
      def cache(name = {}, options = nil, &block)
        @controller.fragment_for(output_buffer, name, options, &block)
      end
    end
  end
end
