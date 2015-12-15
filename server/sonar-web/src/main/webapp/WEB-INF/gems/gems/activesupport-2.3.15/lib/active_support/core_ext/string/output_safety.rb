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

require 'erb'

class ERB
  module Util
    HTML_ESCAPE = { '&' => '&amp;',  '>' => '&gt;',   '<' => '&lt;', '"' => '&quot;' }
    JSON_ESCAPE = { '&' => '\u0026', '>' => '\u003E', '<' => '\u003C' }

    # A utility method for escaping HTML tag characters.
    # This method is also aliased as <tt>h</tt>.
    #
    # In your ERb templates, use this method to escape any unsafe content. For example:
    #   <%=h @person.name %>
    #
    # ==== Example:
    #   puts html_escape("is a > 0 & a < 10?")
    #   # => is a &gt; 0 &amp; a &lt; 10?
    def html_escape(s)
      s = s.to_s
      if s.html_safe?
        s
      else
        s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;").html_safe
      end
    end

    undef :h
    alias h html_escape

    module_function :html_escape
    module_function :h

    # A utility method for escaping HTML entities in JSON strings.
    # This method is also aliased as <tt>j</tt>.
    #
    # In your ERb templates, use this method to escape any HTML entities:
    #   <%=j @person.to_json %>
    #
    # ==== Example:
    #   puts json_escape("is a > 0 & a < 10?")
    #   # => is a \u003E 0 \u0026 a \u003C 10?
    def json_escape(s)
      s.to_s.gsub(/[&"><]/) { |special| JSON_ESCAPE[special] }
    end

    alias j json_escape
    module_function :j
    module_function :json_escape
  end
end

class Object
  def html_safe?
    false
  end
end

class Fixnum
  def html_safe?
    true
  end
end

module ActiveSupport #:nodoc:
  class SafeBuffer < String
    def +(other)
      dup.concat(other)
    end

    def html_safe?
      true
    end

    def html_safe
      self
    end

    def to_s
      self
    end

    def to_yaml(*args)
      to_str.to_yaml(*args)
    end
  end
end

class String
  alias safe_concat concat

  def as_str
    self
  end

  def html_safe
    ActiveSupport::SafeBuffer.new(self)
  end

  def html_safe?
    false
  end
end
