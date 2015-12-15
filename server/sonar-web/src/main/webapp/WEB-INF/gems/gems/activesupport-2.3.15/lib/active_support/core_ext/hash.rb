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

%w(keys indifferent_access deep_merge reverse_merge conversions diff slice except).each do |ext|
  require "active_support/core_ext/hash/#{ext}"
end

class Hash #:nodoc:
  include ActiveSupport::CoreExtensions::Hash::Keys
  include ActiveSupport::CoreExtensions::Hash::IndifferentAccess
  include ActiveSupport::CoreExtensions::Hash::DeepMerge
  include ActiveSupport::CoreExtensions::Hash::ReverseMerge
  include ActiveSupport::CoreExtensions::Hash::Conversions
  include ActiveSupport::CoreExtensions::Hash::Diff
  include ActiveSupport::CoreExtensions::Hash::Slice
  include ActiveSupport::CoreExtensions::Hash::Except
end
