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

package org.sonar.server.usertoken.ws;

import org.sonar.api.server.ws.Request;
import org.sonar.api.server.ws.Response;
import org.sonar.api.server.ws.WebService;
import org.sonar.db.DbClient;
import org.sonar.db.DbSession;
import org.sonar.server.user.UserSession;
import org.sonarqube.ws.client.usertoken.RevokeWsRequest;

import static org.sonar.core.permission.GlobalPermissions.SYSTEM_ADMIN;
import static org.sonarqube.ws.client.usertoken.UserTokensWsParameters.ACTION_REVOKE;
import static org.sonarqube.ws.client.usertoken.UserTokensWsParameters.PARAM_LOGIN;
import static org.sonarqube.ws.client.usertoken.UserTokensWsParameters.PARAM_NAME;

public class RevokeAction implements UserTokensWsAction {
  private final DbClient dbClient;
  private final UserSession userSession;

  public RevokeAction(DbClient dbClient, UserSession userSession) {
    this.dbClient = dbClient;
    this.userSession = userSession;
  }

  @Override
  public void define(WebService.NewController context) {
    WebService.NewAction action = context.createAction(ACTION_REVOKE)
      .setDescription("Revoke a user access token. <br/>"+
        "It requires administration permissions.")
      .setSince("5.3")
      .setPost(true)
      .setHandler(this);

    action.createParam(PARAM_LOGIN)
      .setRequired(true)
      .setDescription("User login")
      .setExampleValue("g.hopper");

    action.createParam(PARAM_NAME)
      .setRequired(true)
      .setDescription("Token name")
      .setExampleValue("Project scan on Travis");
  }

  @Override
  public void handle(Request request, Response response) throws Exception {
    doHandle(toRevokeWsRequest(request));
    response.noContent();
  }

  private void doHandle(RevokeWsRequest request) {
    userSession.checkLoggedIn().checkGlobalPermission(SYSTEM_ADMIN);

    DbSession dbSession = dbClient.openSession(false);
    try {
      dbClient.userTokenDao().deleteByLoginAndName(dbSession, request.getLogin(), request.getName());
      dbSession.commit();
    } finally {
      dbClient.closeSession(dbSession);
    }
  }

  private static RevokeWsRequest toRevokeWsRequest(Request request) {
    return new RevokeWsRequest()
      .setLogin(request.mandatoryParam(PARAM_LOGIN))
      .setName(request.mandatoryParam(PARAM_NAME));
  }
}
