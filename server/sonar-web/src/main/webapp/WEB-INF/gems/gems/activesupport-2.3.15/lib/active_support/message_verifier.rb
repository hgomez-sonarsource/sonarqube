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
  # MessageVerifier makes it easy to generate and verify messages which are signed
  # to prevent tampering.
  # 
  # This is useful for cases like remember-me tokens and auto-unsubscribe links where the
  # session store isn't suitable or available.
  #
  # Remember Me:
  #   cookies[:remember_me] = @verifier.generate([@user.id, 2.weeks.from_now])
  # 
  # In the authentication filter:
  #
  #   id, time = @verifier.verify(cookies[:remember_me])
  #   if time < Time.now
  #     self.current_user = User.find(id)
  #   end
  # 
  class MessageVerifier
    class InvalidSignature < StandardError; end
    
    def initialize(secret, digest = 'SHA1')
      @secret = secret
      @digest = digest
    end
    
    def verify(signed_message)
      raise InvalidSignature if signed_message.blank?

      data, digest = signed_message.split("--")
      if data.present? && digest.present? && secure_compare(digest, generate_digest(data))
        Marshal.load(ActiveSupport::Base64.decode64(data))
      else
        raise InvalidSignature
      end
    end
    
    def generate(value)
      data = ActiveSupport::Base64.encode64s(Marshal.dump(value))
      "#{data}--#{generate_digest(data)}"
    end
    
    private
      if "foo".respond_to?(:force_encoding)
        # constant-time comparison algorithm to prevent timing attacks
        def secure_compare(a, b)
          a = a.dup.force_encoding(Encoding::BINARY)
          b = b.dup.force_encoding(Encoding::BINARY)

          if a.length == b.length
            result = 0
            for i in 0..(a.length - 1)
              result |= a[i].ord ^ b[i].ord
            end
            result == 0
          else
            false
          end
        end
      else
        # For <= 1.8.6
        def secure_compare(a, b)
          if a.length == b.length
            result = 0
            for i in 0..(a.length - 1)
              result |= a[i] ^ b[i]
            end
            result == 0
          else
            false
          end
        end
      end

      def generate_digest(data)
        require 'openssl' unless defined?(OpenSSL)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new(@digest), @secret, data)
      end
  end
end
