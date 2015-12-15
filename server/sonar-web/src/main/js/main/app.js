/*
 * SonarQube
 * Copyright (C) 2009-2016 SonarSource SA
 * mailto:contact AT sonarsource DOT com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
import 'babelify/polyfill';
import $ from 'jquery';
import _ from 'underscore';
import Backbone from 'backbone';
import 'whatwg-fetch';
import moment from 'moment';
import '../libs/third-party/backbone-super.js';
import './processes';
import Navigation from './nav/app';

// set the Backbone's $
Backbone.$ = $;


function requestLocalizationBundle () {
  if (!window.sonarqube.bannedNavigation) {
    return new Promise(resolve => window.requestMessages().done(resolve));
  } else {
    return Promise.resolve();
  }
}

function startNavigation () {
  if (!window.sonarqube.bannedNavigation) {
    return new Navigation().start();
  } else {
    return Promise.resolve();
  }
}

function prepareAppOptions (navResponse) {
  let appOptions = { el: '#content' };
  if (navResponse) {
    appOptions.rootQualifiers = navResponse.global.qualifiers;
    if (navResponse.component) {
      appOptions.component = {
        id: navResponse.component.uuid,
        key: navResponse.component.key,
        name: navResponse.component.name,
        qualifier: _.last(navResponse.component.breadcrumbs).qualifier
      };
    }
  }
  return appOptions;
}

function getPreferredLanguage () {
  return window.navigator.languages ? window.navigator.languages[0] : window.navigator.language;
}

moment.locale(getPreferredLanguage());

window.sonarqube.appStarted = Promise.resolve()
    .then(requestLocalizationBundle)
    .then(startNavigation)
    .then(prepareAppOptions);
