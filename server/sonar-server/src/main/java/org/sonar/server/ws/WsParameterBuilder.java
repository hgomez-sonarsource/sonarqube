/*
 * SonarQube, open source software quality management tool.
 * Copyright (C) 2008-2014 SonarSource
 * mailto:contact AT sonarsource DOT com
 *
 * SonarQube is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * SonarQube is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package org.sonar.server.ws;

import java.util.Set;
import org.sonar.api.i18n.I18n;
import org.sonar.api.resources.ResourceTypes;
import org.sonar.api.server.ws.WebService;
import org.sonar.server.user.UserSession;

import static com.google.common.collect.FluentIterable.from;
import static com.google.common.collect.Ordering.natural;
import static java.lang.String.format;
import static org.sonar.server.component.ResourceTypeFunctions.RESOURCE_TYPE_TO_QUALIFIER;
import static org.sonarqube.ws.client.permission.PermissionsWsParameters.PARAM_QUALIFIER;

public class WsParameterBuilder {
  public static WebService.NewParam createRootQualifierParameter(WebService.NewAction action, QualifierParameterContext context) {
    return action.createParam(PARAM_QUALIFIER)
      .setDescription("Project qualifier. Filter the results with the specified qualifier. Possible values are:" + buildRootQualifiersDescription(context))
      .setPossibleValues(getRootQualifiers(context.getResourceTypes()));
  }

  private static Set<String> getRootQualifiers(ResourceTypes resourceTypes) {
    return from(resourceTypes.getRoots())
      .transform(RESOURCE_TYPE_TO_QUALIFIER)
      .toSortedSet(natural());
  }

  private static String buildRootQualifiersDescription(QualifierParameterContext context) {
    StringBuilder description = new StringBuilder();
    description.append("<ul>");
    String qualifierPattern = "<li>%s - %s</li>";
    for (String qualifier : getRootQualifiers(context.getResourceTypes())) {
      description.append(format(qualifierPattern, qualifier, qualifierLabel(context, qualifier)));
    }
    description.append("</ul>");

    return description.toString();
  }

  private static String qualifierLabel(QualifierParameterContext context, String qualifier) {
    String qualifiersPropertyPrefix = "qualifiers.";
    return context.getI18n().message(context.getUserSession().locale(), qualifiersPropertyPrefix + qualifier, "");
  }

  public static class QualifierParameterContext {
    private final I18n i18n;
    private final ResourceTypes resourceTypes;
    private final UserSession userSession;

    private QualifierParameterContext(UserSession userSession, I18n i18n, ResourceTypes resourceTypes) {
      this.i18n = i18n;
      this.resourceTypes = resourceTypes;
      this.userSession = userSession;
    }

    public static QualifierParameterContext newQualifierParameterContext(UserSession userSession, I18n i18n, ResourceTypes resourceTypes) {
      return new QualifierParameterContext(userSession, i18n, resourceTypes);
    }

    public I18n getI18n() {
      return i18n;
    }

    public ResourceTypes getResourceTypes() {
      return resourceTypes;
    }

    public UserSession getUserSession() {
      return userSession;
    }
  }
}
