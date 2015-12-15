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
import Handlebars from 'hbsfy/runtime';

import StateMigrationFailedPartial from './templates/_maintenance-state-migration-failed.hbs';
import StateMigrationNotSupportedPartial from './templates/_maintenance-state-migration-not-supported.hbs';
import StateMigrationRequiredPartial from './templates/_maintenance-state-migration-required.hbs';
import StateMigrationRunningPartial from './templates/_maintenance-state-migration-running.hbs';
import StateMigrationSucceededPartial from './templates/_maintenance-state-migration-succeeded.hbs';
import StateNoMigrationPartial from './templates/_maintenance-state-no-migration.hbs';

import StatusDownPartial from './templates/_maintenance-status-down.hbs';
import StatusMigrationPartial from './templates/_maintenance-status-migration.hbs';
import StatusUpPartial from './templates/_maintenance-status-up.hbs';

Handlebars.registerPartial('_maintenance-state-migration-failed', StateMigrationFailedPartial);
Handlebars.registerPartial('_maintenance-state-migration-not-supported', StateMigrationNotSupportedPartial);
Handlebars.registerPartial('_maintenance-state-migration-required', StateMigrationRequiredPartial);
Handlebars.registerPartial('_maintenance-state-migration-running', StateMigrationRunningPartial);
Handlebars.registerPartial('_maintenance-state-migration-succeeded', StateMigrationSucceededPartial);
Handlebars.registerPartial('_maintenance-state-no-migration', StateNoMigrationPartial);

Handlebars.registerPartial('_maintenance-status-down', StatusDownPartial);
Handlebars.registerPartial('_maintenance-status-migration', StatusMigrationPartial);
Handlebars.registerPartial('_maintenance-status-up', StatusUpPartial);
