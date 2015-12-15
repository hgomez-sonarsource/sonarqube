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

# Make double-sure the RAILS_ENV is set to test,
# so fixtures are loaded to the right database
silence_warnings { RAILS_ENV = "test" }

require 'test/unit'
require 'action_controller/test_case'
require 'action_view/test_case'
require 'action_controller/integration'
require 'action_mailer/test_case' if defined?(ActionMailer)

if defined?(ActiveRecord)
  require 'active_record/test_case'
  require 'active_record/fixtures'

  class ActiveSupport::TestCase
    include ActiveRecord::TestFixtures
    self.fixture_path = "#{RAILS_ROOT}/test/fixtures/"
    self.use_instantiated_fixtures  = false
    self.use_transactional_fixtures = true
  end

  ActionController::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path

  def create_fixtures(*table_names, &block)
    Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names, {}, &block)
  end
end

begin
  require_library_or_gem 'ruby-debug'
  Debugger.start
  if Debugger.respond_to?(:settings)
    Debugger.settings[:autoeval] = true
    Debugger.settings[:autolist] = 1
  end
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end
