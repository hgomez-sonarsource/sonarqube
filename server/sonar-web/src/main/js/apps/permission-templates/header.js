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
import React from 'react';
import CreateView from './create-view';

export default React.createClass({
  onCreate(e) {
    e.preventDefault();
    new CreateView({
      refresh: this.props.refresh
    }).render();
  },

  renderSpinner () {
    if (this.props.ready) {
      return null;
    }
    return <i className="spinner"/>;
  },

  render() {
    return (
        <header id="project-permissions-header" className="page-header">
          <h1 className="page-title">{window.t('permission_templates.page')}</h1>
          {this.renderSpinner()}
          <div className="page-actions">
            <button onClick={this.onCreate}>Create</button>
          </div>
          <p className="page-description">{window.t('roles.page.description')}</p>
        </header>
    );
  }
});
