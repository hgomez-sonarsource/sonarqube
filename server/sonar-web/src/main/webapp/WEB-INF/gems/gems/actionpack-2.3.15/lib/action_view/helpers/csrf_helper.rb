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
  # = Action View CSRF Helper
  module Helpers
    module CsrfHelper
      # Returns a meta tag with the cross-site request forgery protection token
      # for forms to use. Place this in your head.
      def csrf_meta_tag
        if protect_against_forgery?
          %(<meta name="csrf-param" content="#{h(request_forgery_protection_token)}"/>\n<meta name="csrf-token" content="#{h(form_authenticity_token)}"/>).html_safe
        end
      end
    end
  end
end
