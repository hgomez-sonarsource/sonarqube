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

module ActiveSupport
  if RUBY_VERSION >= '1.9'
    FrozenObjectError = RuntimeError
  else
    FrozenObjectError = TypeError
  end
end

# TODO: Turn all this into using the BacktraceCleaner.
class Exception # :nodoc:
  def clean_message
    Pathname.clean_within message
  end

  TraceSubstitutions = []
  FrameworkStart = /action_controller\/dispatcher\.rb/.freeze
  FrameworkRegexp = /generated|vendor|dispatch|ruby|script\/\w+/.freeze

  def clean_backtrace
    backtrace.collect do |line|
      Pathname.clean_within(TraceSubstitutions.inject(line) do |result, (regexp, sub)|
        result.gsub regexp, sub
      end)
    end
  end

  def application_backtrace
    before_framework_frame = nil
    before_application_frame = true

    trace = clean_backtrace.reject do |line|
      before_framework_frame ||= (line =~ FrameworkStart)
      non_app_frame = (line =~ FrameworkRegexp)
      before_application_frame = false unless non_app_frame
      before_framework_frame || (non_app_frame && !before_application_frame)
    end

    # If we didn't find any application frames, return an empty app trace.
    before_application_frame ? [] : trace
  end

  def framework_backtrace
    clean_backtrace.grep FrameworkRegexp
  end
end
