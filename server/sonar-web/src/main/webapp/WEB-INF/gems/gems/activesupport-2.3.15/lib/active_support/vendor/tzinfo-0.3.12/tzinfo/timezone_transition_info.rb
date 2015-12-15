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

require 'date'
require 'tzinfo/time_or_datetime'

module TZInfo
  # Represents an offset defined in a Timezone data file.
  class TimezoneTransitionInfo #:nodoc:
    # The offset this transition changes to (a TimezoneOffsetInfo instance).
    attr_reader :offset
    
    # The offset this transition changes from (a TimezoneOffsetInfo instance).
    attr_reader :previous_offset
    
    # The numerator of the DateTime if the transition time is defined as a 
    # DateTime, otherwise the transition time as a timestamp.
    attr_reader :numerator_or_time
    protected :numerator_or_time
    
    # Either the denominotor of the DateTime if the transition time is defined
    # as a DateTime, otherwise nil. 
    attr_reader :denominator
    protected :denominator
    
    # Creates a new TimezoneTransitionInfo with the given offset, 
    # previous_offset (both TimezoneOffsetInfo instances) and UTC time. 
    # if denominator is nil, numerator_or_time is treated as a number of 
    # seconds since the epoch. If denominator is specified numerator_or_time
    # and denominator are used to create a DateTime as follows:
    # 
    #  DateTime.new!(Rational.send(:new!, numerator_or_time, denominator), 0, Date::ITALY)
    #
    # For performance reasons, the numerator and denominator must be specified
    # in their lowest form.
    def initialize(offset, previous_offset, numerator_or_time, denominator = nil)
      @offset = offset
      @previous_offset = previous_offset
      @numerator_or_time = numerator_or_time
      @denominator = denominator
      
      @at = nil
      @local_end = nil
      @local_start = nil
    end
    
    # A TimeOrDateTime instance representing the UTC time when this transition
    # occurs.
    def at
      unless @at
        unless @denominator 
          @at = TimeOrDateTime.new(@numerator_or_time)
        else
          r = RubyCoreSupport.rational_new!(@numerator_or_time, @denominator)
          dt = RubyCoreSupport.datetime_new!(r, 0, Date::ITALY)
          @at = TimeOrDateTime.new(dt)
        end
      end
      
      @at
    end
    
    # A TimeOrDateTime instance representing the local time when this transition
    # causes the previous observance to end (calculated from at using 
    # previous_offset).
    def local_end
      @local_end = at.add_with_convert(@previous_offset.utc_total_offset) unless @local_end      
      @local_end
    end
    
    # A TimeOrDateTime instance representing the local time when this transition
    # causes the next observance to start (calculated from at using offset).
    def local_start
      @local_start = at.add_with_convert(@offset.utc_total_offset) unless @local_start
      @local_start
    end
    
    # Returns true if this TimezoneTransitionInfo is equal to the given
    # TimezoneTransitionInfo. Two TimezoneTransitionInfo instances are 
    # considered to be equal by == if offset, previous_offset and at are all 
    # equal.
    def ==(tti)
      tti.respond_to?(:offset) && tti.respond_to?(:previous_offset) && tti.respond_to?(:at) &&
        offset == tti.offset && previous_offset == tti.previous_offset && at == tti.at
    end
    
    # Returns true if this TimezoneTransitionInfo is equal to the given
    # TimezoneTransitionInfo. Two TimezoneTransitionInfo instances are 
    # considered to be equal by eql? if offset, previous_offset, 
    # numerator_or_time and denominator are all equal. This is stronger than ==,
    # which just requires the at times to be equal regardless of how they were
    # originally specified.
    def eql?(tti)
      tti.respond_to?(:offset) && tti.respond_to?(:previous_offset) &&
        tti.respond_to?(:numerator_or_time) && tti.respond_to?(:denominator) &&
        offset == tti.offset && previous_offset == tti.previous_offset &&
        numerator_or_time == tti.numerator_or_time && denominator == tti.denominator        
    end
    
    # Returns a hash of this TimezoneTransitionInfo instance.
    def hash
      @offset.hash ^ @previous_offset.hash ^ @numerator_or_time.hash ^ @denominator.hash
    end
    
    # Returns internal object state as a programmer-readable string.
    def inspect
      "#<#{self.class}: #{at.inspect},#{@offset.inspect}>"      
    end
  end
end
