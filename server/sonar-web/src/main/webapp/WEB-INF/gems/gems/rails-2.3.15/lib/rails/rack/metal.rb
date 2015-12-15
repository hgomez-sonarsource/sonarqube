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

require 'active_support/ordered_hash'

module Rails
  module Rack
    class Metal
      NotFoundResponse = [404, {}, []].freeze
      NotFound = lambda { NotFoundResponse }

      cattr_accessor :metal_paths
      self.metal_paths = ["#{Rails.root}/app/metal"]
      cattr_accessor :requested_metals

      def self.metals
        matcher = /#{Regexp.escape('/app/metal/')}(.*)\.rb\Z/
        metal_glob = metal_paths.map{ |base| "#{base}/**/*.rb" }
        all_metals = {}

        metal_glob.each do |glob|
          Dir[glob].sort.map do |file|
            file = file.match(matcher)[1]
            all_metals[file.camelize] = file
          end
        end

        load_list = requested_metals || all_metals.keys

        load_list.map do |requested_metal|
          if metal = all_metals[requested_metal]
            require_dependency metal
            requested_metal.constantize
          end
        end.compact
      end

      def initialize(app)
        @app = app
        @metals = ActiveSupport::OrderedHash.new
        self.class.metals.each { |app| @metals[app] = true }
        freeze
      end

      def call(env)
        @metals.keys.each do |app|
          result = app.call(env)
          return result unless result[0].to_i == 404
        end
        @app.call(env)
      end
    end
  end
end
