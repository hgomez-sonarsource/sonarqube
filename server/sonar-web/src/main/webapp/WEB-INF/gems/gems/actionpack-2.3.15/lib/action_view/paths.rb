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

module ActionView #:nodoc:
  class PathSet < Array #:nodoc:
    def self.type_cast(obj)
      if obj.is_a?(String)
        if Base.cache_template_loading?
          Template::EagerPath.new(obj.to_s)
        else
          ReloadableTemplate::ReloadablePath.new(obj.to_s)
        end
      else
        obj
      end
    end
    
    def initialize(*args)
      super(*args).map! { |obj| self.class.type_cast(obj) }
    end

    def <<(obj)
      super(self.class.type_cast(obj))
    end

    def concat(array)
      super(array.map! { |obj| self.class.type_cast(obj) })
    end

    def insert(index, obj)
      super(index, self.class.type_cast(obj))
    end

    def push(*objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end

    def unshift(*objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end
    
    def load!
      each(&:load!)
    end

    def find_template(original_template_path, format = nil, html_fallback = true)
      return original_template_path if original_template_path.respond_to?(:render)
      template_path = original_template_path.sub(/^\//, '')

      each do |load_path|
        if format && (template = load_path["#{template_path}.#{I18n.locale}.#{format}"])
          return template
        # Try the default locale version if the current locale doesn't have one
        # (i.e. you haven't translated this view to German yet, but you have the English version on hand)
        elsif format && (template = load_path["#{template_path}.#{I18n.default_locale}.#{format}"]) 
          return template
        elsif format && (template = load_path["#{template_path}.#{format}"])
          return template
        elsif template = load_path["#{template_path}.#{I18n.locale}"]
          return template
        elsif template = load_path["#{template_path}.#{I18n.default_locale}"]
          return template
        elsif template = load_path[template_path]
          return template
        # Try to find html version if the format is javascript
        elsif format == :js && html_fallback && template = load_path["#{template_path}.#{I18n.locale}.html"]
          return template
        elsif format == :js && html_fallback && template = load_path["#{template_path}.#{I18n.default_locale}.html"]
          return template
        elsif format == :js && html_fallback && template = load_path["#{template_path}.html"]
          return template
        end
      end

      return Template.new(original_template_path) if File.file?(original_template_path)

      raise MissingTemplate.new(self, original_template_path, format)
    end
  end
end
