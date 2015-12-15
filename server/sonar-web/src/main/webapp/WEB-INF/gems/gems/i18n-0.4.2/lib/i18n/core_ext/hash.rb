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

class Hash
  def slice(*keep_keys)
    h = {}
    keep_keys.each { |key| h[key] = fetch(key) }
    h
  end unless Hash.method_defined?(:slice)

  def except(*less_keys)
    slice(*keys - less_keys)
  end unless Hash.method_defined?(:except)

  def deep_symbolize_keys
    inject({}) { |result, (key, value)|
      value = value.deep_symbolize_keys if value.is_a?(Hash)
      result[(key.to_sym rescue key) || key] = value
      result
    }
  end unless Hash.method_defined?(:deep_symbolize_keys)

  # deep_merge_hash! by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
  MERGER = proc do |key, v1, v2|
    Hash === v1 && Hash === v2 ? v1.merge(v2, &MERGER) : v2
  end
  
  def deep_merge!(data)
    merge!(data, &MERGER)
  end unless Hash.method_defined?(:deep_merge!)
end

