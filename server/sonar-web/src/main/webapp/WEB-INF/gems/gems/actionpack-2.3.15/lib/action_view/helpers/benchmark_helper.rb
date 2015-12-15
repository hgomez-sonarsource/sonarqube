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

require 'benchmark'

module ActionView
  module Helpers
    # This helper offers a method to measure the execution time of a block 
    # in a template.
    module BenchmarkHelper
      # Allows you to measure the execution time of a block 
      # in a template and records the result to the log. Wrap this block around
      # expensive operations or possible bottlenecks to get a time reading
      # for the operation.  For example, let's say you thought your file 
      # processing method was taking too long; you could wrap it in a benchmark block.
      #
      #  <% benchmark "Process data files" do %>
      #    <%= expensive_files_operation %>
      #  <% end %>
      #
      # That would add something like "Process data files (345.2ms)" to the log,
      # which you can then use to compare timings when optimizing your code.
      #
      # You may give an optional logger level as the :level option.
      # (:debug, :info, :warn, :error); the default value is :info.
      #
      #  <% benchmark "Low-level files", :level => :debug do %>
      #    <%= lowlevel_files_operation %>
      #  <% end %>
      #
      # Finally, you can pass true as the third argument to silence all log activity 
      # inside the block. This is great for boiling down a noisy block to just a single statement:
      #
      #  <% benchmark "Process data files", :level => :info, :silence => true do %>
      #    <%= expensive_and_chatty_files_operation %>
      #  <% end %>
      def benchmark(message = "Benchmarking", options = {})
        if controller.logger
          if options.is_a?(Symbol)
            ActiveSupport::Deprecation.warn("use benchmark('#{message}', :level => :#{options}) instead", caller)
            options = { :level => options, :silence => false }
          else
            options.assert_valid_keys(:level, :silence)
            options[:level] ||= :info
          end
          
          result = nil
          ms = Benchmark.ms { result = options[:silence] ? controller.logger.silence { yield } : yield }
          controller.logger.send(options[:level], '%s (%.1fms)' % [ message, ms ])
          result
        else
          yield
        end
      end
    end
  end
end
