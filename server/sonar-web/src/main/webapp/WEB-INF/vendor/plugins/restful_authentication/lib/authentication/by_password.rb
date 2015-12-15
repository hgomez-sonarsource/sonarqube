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

module Authentication
  module ByPassword
    # Stuff directives into including module
    def self.included(recipient)
      recipient.extend(ModelClassMethods)
      recipient.class_eval do
        include ModelInstanceMethods
        
        # Virtual attribute for the unencrypted password
        attr_accessor :password
        validates_presence_of     :password,                   :if => :password_required?
        validates_presence_of     :password_confirmation,      :if => :password_required?
        validates_confirmation_of :password,                   :if => :password_required?
        validates_length_of       :password, :within => 4..40, :if => :password_required?
        before_save :encrypt_password
      end
    end # #included directives

    #
    # Class Methods
    #
    module ModelClassMethods
      # This provides a modest increased defense against a dictionary attack if
      # your db were ever compromised, but will invalidate existing passwords.
      # See the README and the file config/initializers/site_keys.rb
      #
      # It may not be obvious, but if you set REST_AUTH_SITE_KEY to nil and
      # REST_AUTH_DIGEST_STRETCHES to 1 you'll have backwards compatibility with
      # older versions of restful-authentication.
      def password_digest(password, salt)
        digest = REST_AUTH_SITE_KEY
        REST_AUTH_DIGEST_STRETCHES.times do
          digest = secure_digest(digest, salt, password, REST_AUTH_SITE_KEY)
        end
        digest
      end      
    end # class methods

    #
    # Instance Methods
    #
    module ModelInstanceMethods
      
      # Encrypts the password with the user salt
      def encrypt(password)
        self.class.password_digest(password, salt)
      end
      
      def authenticated?(password)
        crypted_password == encrypt(password)
      end
      
      # before filter 
      def encrypt_password
        return if password.blank?
        self.salt = self.class.make_token if new_record?
        self.crypted_password = encrypt(password)
      end
      def password_required?
        crypted_password.blank? || !password.blank?
      end
    end # instance methods
  end
end
