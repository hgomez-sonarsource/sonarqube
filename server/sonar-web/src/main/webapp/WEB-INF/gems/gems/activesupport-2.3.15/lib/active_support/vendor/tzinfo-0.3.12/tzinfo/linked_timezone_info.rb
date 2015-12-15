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

require 'tzinfo/timezone_info'

module TZInfo
  # Represents a linked timezone defined in a data module.
  class LinkedTimezoneInfo < TimezoneInfo #:nodoc:
        
    # The zone that provides the data (that this zone is an alias for).
    attr_reader :link_to_identifier
    
    # Constructs a new TimezoneInfo with an identifier and the identifier
    # of the zone linked to.
    def initialize(identifier, link_to_identifier)
      super(identifier)
      @link_to_identifier = link_to_identifier      
    end
    
    # Returns internal object state as a programmer-readable string.
    def inspect
      "#<#{self.class}: #@identifier,#@link_to_identifier>"
    end
  end
end
