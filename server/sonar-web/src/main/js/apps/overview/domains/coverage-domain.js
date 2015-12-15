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
import d3 from 'd3';
import React from 'react';

import { getMeasuresAndVariations } from '../../../api/measures';
import { DomainTimeline } from '../components/domain-timeline';
import { DomainTreemap } from '../components/domain-treemap';
import { DomainBubbleChart } from '../components/domain-bubble-chart';
import { CoverageSelectionMixin } from '../components/coverage-selection-mixin';
import { getPeriodLabel, getPeriodDate } from './../helpers/periods';
import { TooltipsMixin } from '../../../components/mixins/tooltips-mixin';
import { filterMetrics, filterMetricsForDomains } from '../helpers/metrics';
import { DomainLeakTitle } from '../main/components';
import { CHART_REVERSED_COLORS_RANGE_PERCENT } from '../../../helpers/constants';
import { CoverageMeasuresList } from '../components/coverage-measures-list';


const TEST_DOMAINS = ['Tests', 'Tests (Integration)', 'Tests (Overall)'];


export const CoverageMain = React.createClass({
  mixins: [TooltipsMixin, CoverageSelectionMixin],

  getInitialState() {
    return {
      ready: false,
      leakPeriodLabel: getPeriodLabel(this.props.component.periods, this.props.leakPeriodIndex),
      leakPeriodDate: getPeriodDate(this.props.component.periods, this.props.leakPeriodIndex)
    };
  },

  componentDidMount() {
    this.requestMeasures().then(r => {
      let measures = this.getMeasuresValues(r, 'value');
      let leak = this.getMeasuresValues(r, 'var' + this.props.leakPeriodIndex);
      this.setState({
        ready: true,
        measures,
        leak,
        coverageMetricPrefix: this.getCoverageMetricPrefix(measures)
      });
    });
  },

  getMeasuresValues (measures, fieldKey) {
    let values = {};
    Object.keys(measures).forEach(measureKey => {
      values[measureKey] = measures[measureKey][fieldKey];
    });
    return values;
  },

  getMetricsForDomain() {
    return this.props.metrics
        .filter(metric => TEST_DOMAINS.indexOf(metric.domain) !== -1)
        .map(metric => metric.key);
  },

  getMetricsForTimeline() {
    return filterMetricsForDomains(this.props.metrics, TEST_DOMAINS);
  },

  getAllMetricsForTimeline() {
    return filterMetrics(this.props.metrics);
  },

  requestMeasures () {
    return getMeasuresAndVariations(this.props.component.key, this.getMetricsForDomain());
  },

  renderLoading () {
    return <div className="text-center">
      <i className="spinner spinner-margin"/>
    </div>;
  },

  renderEmpty() {
    return <div className="overview-detailed-page">
      <div className="page">
        <p>{window.t('overview.no_coverage')}</p>
      </div>
    </div>;
  },

  renderLegend () {
    return <DomainLeakTitle inline={true} label={this.state.leakPeriodLabel} date={this.state.leakPeriodDate}/>;
  },

  render () {
    if (!this.state.ready) {
      return this.renderLoading();
    }

    let treemapScale = d3.scale.linear()
        .domain([0, 25, 50, 75, 100])
        .range(CHART_REVERSED_COLORS_RANGE_PERCENT);

    let coverageMetric = this.state.coverageMetricPrefix + 'coverage';
    let uncoveredLinesMetric = this.state.coverageMetricPrefix + 'uncovered_lines';

    if (this.state.measures[coverageMetric] == null) {
      return this.renderEmpty();
    }

    return <div className="overview-detailed-page">
      <div className="overview-cards-list">
        <div className="overview-card overview-card-fixed-width">
          <div className="overview-card-header">
            <div className="overview-title">{window.t('overview.domain.coverage')}</div>
            {this.renderLegend()}
          </div>
          <CoverageMeasuresList {...this.props} {...this.state}/>
        </div>

        <div className="overview-card">
          <DomainBubbleChart {...this.props}
              xMetric="complexity"
              yMetric={coverageMetric}
              sizeMetrics={[uncoveredLinesMetric]}/>
        </div>
      </div>

      <div className="overview-cards-list">
        <div className="overview-card">
          <DomainTimeline {...this.props} {...this.state}
              initialMetric={coverageMetric}
              metrics={this.getMetricsForTimeline()}
              allMetrics={this.getAllMetricsForTimeline()}/>
        </div>

        <div className="overview-card">
          <DomainTreemap {...this.props}
              sizeMetric="ncloc"
              colorMetric={coverageMetric}
              scale={treemapScale}/>
        </div>
      </div>
    </div>;

  }
});
