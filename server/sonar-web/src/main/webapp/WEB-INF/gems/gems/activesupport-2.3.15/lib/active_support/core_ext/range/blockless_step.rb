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
    module Range #:nodoc:
      # Return an array when step is called without a block.
      module BlocklessStep
        def self.included(base) #:nodoc:
          base.alias_method_chain :step, :blockless
        end

        if RUBY_VERSION < '1.9'
          def step_with_blockless(value = 1, &block)
            if block_given?
              step_without_blockless(value, &block)
            else
              [].tap do |array|
                step_without_blockless(value) { |step| array << step }
              end
            end
          end
        else
          def step_with_blockless(value = 1, &block)
            if block_given?
              step_without_blockless(value, &block)
            else
              step_without_blockless(value).to_a
            end
          end
        end
      end
    end
  end
end
