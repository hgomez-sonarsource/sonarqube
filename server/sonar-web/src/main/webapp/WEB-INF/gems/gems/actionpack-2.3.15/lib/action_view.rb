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

begin
  require 'active_support'
rescue LoadError
  activesupport_path = "#{File.dirname(__FILE__)}/../../activesupport/lib"
  if File.directory?(activesupport_path)
    $:.unshift activesupport_path
    require 'active_support'
  end
end

module ActionView
  def self.load_all!
    [Base, InlineTemplate, TemplateError]
  end

  autoload :Base, 'action_view/base'
  autoload :Helpers, 'action_view/helpers'
  autoload :InlineTemplate, 'action_view/inline_template'
  autoload :Partials, 'action_view/partials'
  autoload :PathSet, 'action_view/paths'
  autoload :Renderable, 'action_view/renderable'
  autoload :RenderablePartial, 'action_view/renderable_partial'
  autoload :Template, 'action_view/template'
  autoload :ReloadableTemplate, 'action_view/reloadable_template'
  autoload :TemplateError, 'action_view/template_error'
  autoload :TemplateHandler, 'action_view/template_handler'
  autoload :TemplateHandlers, 'action_view/template_handlers'
  autoload :Helpers, 'action_view/helpers'
end

require 'active_support/core_ext/string/output_safety'

ActionView::SafeBuffer = ActiveSupport::Deprecation::DeprecatedConstantProxy.new('ActionView::SafeBuffer', 'ActiveSupport::SafeBuffer')

I18n.load_path << "#{File.dirname(__FILE__)}/action_view/locale/en.yml"
