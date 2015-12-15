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

#
# SonarQube 5.1
#
class RenameIssuesLongDates < ActiveRecord::Migration

  def self.up
    rename_column 'issues', 'issue_creation_date_ms', 'issue_creation_date'
    rename_column 'issues', 'issue_update_date_ms', 'issue_update_date'
    rename_column 'issues', 'issue_close_date_ms', 'issue_close_date'
    add_index 'issues', 'issue_creation_date', :name => 'issues_creation_date'
  end

end

