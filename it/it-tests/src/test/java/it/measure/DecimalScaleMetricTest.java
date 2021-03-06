package it.measure;

import com.sonar.orchestrator.Orchestrator;
import it.Category3Suite;
import org.junit.ClassRule;
import org.junit.Test;
import org.sonar.wsclient.services.Resource;
import org.sonar.wsclient.services.ResourceQuery;
import util.ItUtils;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * SONAR-6939
 */
public class DecimalScaleMetricTest {

  /**
   * Requires the plugin "batch-plugin" 
   */
  @ClassRule
  public static Orchestrator orchestrator = Category3Suite.ORCHESTRATOR;

  @Test
  public void override_decimal_scale_of_numeric_metric() {
    String projectKey = "DecimalScaleMetricTest.override_decimal_scale_of_numeric_metric";
    // see DecimalScaleMetric
    String metricKey = "decimal_scale";
    ItUtils.runProjectAnalysis(orchestrator, "shared/xoo-sample",
      "sonar.projectKey", projectKey,
      "sonar.scanner.feedDecimalScaleMetric", String.valueOf(true));

    Resource resource = orchestrator.getServer().getWsClient()
      .find(ResourceQuery.createForMetrics(projectKey, metricKey));
    // Ability to define decimal scale of metrics was introduced in v5.3. By default it is 1.
    assertThat(resource.getMeasureValue(metricKey)).isEqualTo(0.0001);
    assertThat(resource.getMeasureFormattedValue(metricKey, null)).isEqualTo("0.0001");
  }
}
