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

# -*- coding: utf-8 -*-
module Authentication
  module ByCookieToken
    # Stuff directives into including module 
    def self.included(recipient)
      recipient.extend(ModelClassMethods)
      recipient.class_eval do
        include ModelInstanceMethods
      end
    end

    #
    # Class Methods
    #
    module ModelClassMethods
    end # class methods

    #
    # Instance Methods
    #
    module ModelInstanceMethods
      def remember_token?
        (!remember_token.blank?) && 
          remember_token_expires_at && (Time.now.utc < remember_token_expires_at.utc)
      end

      # These create and unset the fields required for remembering users between browser closes
      def remember_me
        remember_me_for 2.weeks
      end

      def remember_me_for(time)
        remember_me_until time.from_now.utc
      end

      def remember_me_until(time)
        self.remember_token_expires_at = time
        self.remember_token            = self.class.make_token
        save(false)
      end

      # refresh token (keeping same expires_at) if it exists
      def refresh_token
        if remember_token?
          self.remember_token = self.class.make_token
          # Skip before_update as it populate dates columns with a long value (see migrations 752 to 754)
          send(:update_without_callbacks)
        end
      end

      # 
      # Deletes the server-side record of the authentication token.  The
      # client-side (browser cookie) and server-side (this remember_token) must
      # always be deleted together.
      #
      def forget_me
        self.remember_token_expires_at = nil
        self.remember_token            = nil
        save(false)
      end
    end # instance methods
  end

  module ByCookieTokenController
    # Stuff directives into including module 
    def self.included( recipient )
      recipient.extend( ControllerClassMethods )
      recipient.class_eval do
        include ControllerInstanceMethods
      end
    end

    #
    # Class Methods
    #
    module ControllerClassMethods
    end # class methods
    
    module ControllerInstanceMethods
    end # instance methods
  end
end

