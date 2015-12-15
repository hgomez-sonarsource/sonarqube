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

# Only for Rails 2.2. It is included in Rails 2.3.
# Get loaded locales conveniently 
# See http://rails-i18n.org/wiki/pages/i18n-available_locales
module I18n
  class << self  
    def available_locales; backend.available_locales; end  
  end  
  module Backend 
    class Simple 
      def available_locales; translations.keys.collect { |l| l.to_s }.sort; end  
    end  
  end 
end 

# You need to "force-initialize" loaded locales 
I18n.backend.send(:init_translations) 
AVAILABLE_LOCALES = I18n.backend.available_locales 