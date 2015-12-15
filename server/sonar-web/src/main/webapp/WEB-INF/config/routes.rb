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

ActionController::Routing::Routes.draw do |map|
  map.namespace :api do |api|
    api.resources :events, :only => [:index, :show, :create, :destroy]
    api.resources :user_properties, :only => [:index, :show, :create, :destroy], :requirements => { :id => /.*/ }
    api.resources :projects, :only => [:index], :requirements => { :id => /.*/ }
    api.resources :favourites, :only => [:index, :show, :create, :destroy], :requirements => { :id => /.*/ }
  end

  map.connect 'api', :controller => 'api/java_ws', :action => 'redirect_to_ws_listing'

  # deprecated, sonar-runner should use batch/index and batch/file?name=xxx
  map.connect 'batch_bootstrap/index', :controller => 'api/java_ws', :action => 'index', :wspath => 'batch', :wsaction => 'index'
  map.connect 'batch/:name', :controller => 'api/java_ws', :action => 'index', :wspath => 'batch', :wsaction => 'file', :requirements => { :name => /.*/ }

  map.connect 'api/server/:action', :controller => 'api/server'
  map.connect 'api/resoures', :controller => 'api/resources', :action => 'index'
  map.connect 'api/sources', :controller => 'api/sources', :action => 'index'

  map.resources 'properties', :path_prefix => 'api', :controller => 'api/properties', :requirements => { :id => /.*/ }

  # home page
  map.home '', :controller => :dashboard, :action => :index
  map.root :controller => :dashboard, :action => :index

  # page plugins
  map.connect 'plugins/configuration/:page', :controller => 'plugins/configuration', :action => 'index', :requirements => { :page => /.*/ }
  map.connect 'plugins/home/:page', :controller => 'plugins/home', :action => 'index', :requirements => { :page => /.*/ }
  map.connect 'plugins/resource/:id', :controller => 'plugins/resource', :action => 'index', :requirements => { :id => /.*/ }

  # to refactor
  map.connect 'charts/:action/:project_id/:metric_id', :controller => 'charts'
  map.connect 'rules_configuration/:action/:language/:name/:plugin.:format', :controller => 'rules_configuration'

  map.connect 'api_documentation/*other', :controller => 'api_documentation', :action => 'index'
  map.connect 'quality_gates/*other', :controller => 'quality_gates', :action => 'index'
  map.connect 'overview/*other', :controller => 'overview', :action => 'index'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id', :requirements => { :id => /.*/ }

end
