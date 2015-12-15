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
import AllMeasuresPartial from './templates/measures/_source-viewer-measures-all.hbs';
import CoveragePartial from './templates/measures/_source-viewer-measures-coverage.hbs';
import DuplicationsPartial from './templates/measures/_source-viewer-measures-duplications.hbs';
import IssuesPartial from './templates/measures/_source-viewer-measures-issues.hbs';
import LinesPartial from './templates/measures/_source-viewer-measures-lines.hbs';
import TestCasesPartial from './templates/measures/_source-viewer-measures-test-cases.hbs';
import TestsPartial from './templates/measures/_source-viewer-measures-tests.hbs';

Handlebars.registerPartial('_source-viewer-measures-all', AllMeasuresPartial);
Handlebars.registerPartial('_source-viewer-measures-coverage', CoveragePartial);
Handlebars.registerPartial('_source-viewer-measures-duplications', DuplicationsPartial);
Handlebars.registerPartial('_source-viewer-measures-issues', IssuesPartial);
Handlebars.registerPartial('_source-viewer-measures-lines', LinesPartial);
Handlebars.registerPartial('_source-viewer-measures-test-cases', TestCasesPartial);
Handlebars.registerPartial('_source-viewer-measures-tests', TestsPartial);
