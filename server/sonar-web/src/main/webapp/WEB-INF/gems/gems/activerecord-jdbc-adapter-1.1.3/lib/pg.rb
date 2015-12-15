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

# Stub library for postgresql -- allows Rails to load
# postgresql_adapter without error. Other than postgres-pr, there's no
# other way to use PostgreSQL on JRuby anyway, right? If you've
# installed ar-jdbc you probably want to use that to connect to pg.
#
# If by chance this library is installed in another Ruby and this file
# got required then we'll just continue to try to load the next pg.rb
# in the $LOAD_PATH.

unless defined?(JRUBY_VERSION)
  gem 'pg' if respond_to?(:gem)   # make sure pg gem is activated
  after_current_file = false
  $LOAD_PATH.each do |p|
    require_file = File.join(p, 'pg.rb')

    if File.expand_path(require_file) == File.expand_path(__FILE__)
      after_current_file = true
      next
    end

    if after_current_file && File.exist?(require_file)
      load require_file
      break
    end
  end
end
