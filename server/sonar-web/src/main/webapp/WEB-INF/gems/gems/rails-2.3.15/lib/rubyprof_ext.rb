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

require 'prof'

module Prof #:nodoc:
  # Adapted from Shugo Maeda's unprof.rb
  def self.print_profile(results, io = $stderr)
    total = results.detect { |i|
      i.method_class.nil? && i.method_id == :"#toplevel"
    }.total_time
    total = 0.001 if total < 0.001

    io.puts "  %%   cumulative   self              self     total"
    io.puts " time   seconds   seconds    calls  ms/call  ms/call  name"

    sum = 0.0
    for r in results
      sum += r.self_time

      name =  if r.method_class.nil?
                r.method_id.to_s
              elsif r.method_class.is_a?(Class)
                "#{r.method_class}##{r.method_id}"
              else
                "#{r.method_class}.#{r.method_id}"
              end
      io.printf "%6.2f %8.3f  %8.3f %8d %8.2f %8.2f  %s\n",
        r.self_time / total * 100,
        sum,
        r.self_time,
        r.count,
        r.self_time * 1000 / r.count,
        r.total_time * 1000 / r.count,
        name
    end
  end
end
