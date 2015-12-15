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

# These class attributes behave something like the class
# inheritable accessors.  But instead of copying the hash over at
# the time the subclass is first defined,  the accessors simply
# delegate to their superclass unless they have been given a 
# specific value.  This stops the strange situation where values 
# set after class definition don't get applied to subclasses.
class Class
  def superclass_delegating_reader(*names)
    class_name_to_stop_searching_on = self.superclass.name.blank? ? "Object" : self.superclass.name
    names.each do |name|
      class_eval <<-EOS
      def self.#{name}                                            # def self.only_reader
        if defined?(@#{name})                                     #   if defined?(@only_reader)
          @#{name}                                                #     @only_reader
        elsif superclass < #{class_name_to_stop_searching_on} &&  #   elsif superclass < Object &&
              superclass.respond_to?(:#{name})                    #         superclass.respond_to?(:only_reader)
          superclass.#{name}                                      #     superclass.only_reader
        end                                                       #   end
      end                                                         # end
      def #{name}                                                 # def only_reader
        self.class.#{name}                                        #   self.class.only_reader
      end                                                         # end
      def self.#{name}?                                           # def self.only_reader?
        !!#{name}                                                 #   !!only_reader
      end                                                         # end
      def #{name}?                                                # def only_reader?
        !!#{name}                                                 #   !!only_reader
      end                                                         # end
      EOS
    end
  end

  def superclass_delegating_writer(*names)
    names.each do |name|
      class_eval <<-EOS
        def self.#{name}=(value)  # def self.only_writer=(value)
          @#{name} = value        #   @only_writer = value
        end                       # end
      EOS
    end
  end

  def superclass_delegating_accessor(*names)
    superclass_delegating_reader(*names)
    superclass_delegating_writer(*names)
  end
end
