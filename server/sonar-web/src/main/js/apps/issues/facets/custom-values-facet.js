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
import _ from 'underscore';
import BaseFacet from './base-facet';
import Template from '../templates/facets/issues-custom-values-facet.hbs';

export default BaseFacet.extend({
  template: Template,

  events: function () {
    return _.extend(BaseFacet.prototype.events.apply(this, arguments), {
      'change .js-custom-value': 'addCustomValue'
    });
  },

  getUrl: function () {

  },

  onRender: function () {
    BaseFacet.prototype.onRender.apply(this, arguments);
    return this.prepareSearch();
  },

  prepareSearch: function () {
    return this.$('.js-custom-value').select2({
      placeholder: 'Search...',
      minimumInputLength: 2,
      allowClear: false,
      formatNoMatches: function () {
        return window.t('select2.noMatches');
      },
      formatSearching: function () {
        return window.t('select2.searching');
      },
      formatInputTooShort: function () {
        return window.tp('select2.tooShort', 2);
      },
      width: '100%',
      ajax: this.prepareAjaxSearch()
    });
  },

  prepareAjaxSearch: function () {
    return {
      quietMillis: 300,
      url: this.getUrl(),
      data: function (term, page) {
        return { s: term, p: page };
      },
      results: function (data) {
        return { more: data.more, results: data.results };
      }
    };
  },

  addCustomValue: function () {
    var property = this.model.get('property'),
        customValue = this.$('.js-custom-value').select2('val'),
        value = this.getValue();
    if (value.length > 0) {
      value += ',';
    }
    value += customValue;
    var obj = {};
    obj[property] = value;
    return this.options.app.state.updateFilter(obj);
  }
});
