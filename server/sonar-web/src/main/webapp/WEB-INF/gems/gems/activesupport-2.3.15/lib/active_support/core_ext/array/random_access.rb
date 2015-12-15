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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Array #:nodoc:
      module RandomAccess
        # This method is deprecated because it masks Kernel#rand within the Array class itself, 
        # which may be used by a 3rd party library extending Array in turn. See
        #
        #   https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/4555
        #
        def rand # :nodoc:
          ActiveSupport::Deprecation.warn 'Array#rand is deprecated and will be removed in Rails 3. Use Array#sample instead', caller
          sample
        end

        # Returns a random element from the array.
        def random_element # :nodoc:
          ActiveSupport::Deprecation.warn 'Array#random_element is deprecated and will be removed in Rails 3. Use Array#sample instead', caller
          sample
        end

        # Backport of Array#sample based on Marc-Andre Lafortune's http://github.com/marcandre/backports/
        def sample(n=nil)
          return self[Kernel.rand(size)] if n.nil?
          n = n.to_int
        rescue Exception => e
          raise TypeError, "Coercion error: #{n.inspect}.to_int => Integer failed:\n(#{e.message})"
        else
          raise TypeError, "Coercion error: #{n}.to_int did NOT return an Integer (was #{n.class})" unless n.kind_of? ::Integer
          raise ArgumentError, "negative array size" if n < 0
          n = size if n > size
          result = ::Array.new(self)
          n.times do |i|
            r = i + Kernel.rand(size - i)
            result[i], result[r] = result[r], result[i]
          end
          result[n..size] = []
          result
        end unless method_defined? :sample
      end
    end
  end
end
