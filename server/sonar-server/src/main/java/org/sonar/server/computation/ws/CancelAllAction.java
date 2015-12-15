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
package org.sonar.server.computation.ws;

import org.sonar.api.server.ws.Request;
import org.sonar.api.server.ws.Response;
import org.sonar.api.server.ws.WebService;
import org.sonar.api.web.UserRole;
import org.sonar.server.computation.queue.CeQueue;
import org.sonar.server.user.UserSession;

public class CancelAllAction implements CeWsAction {

  private final UserSession userSession;
  private final CeQueue queue;

  public CancelAllAction(UserSession userSession, CeQueue queue) {
    this.userSession = userSession;
    this.queue = queue;
  }

  @Override
  public void define(WebService.NewController controller) {
    controller.createAction("cancel_all")
      .setDescription("Cancels all pending tasks. Requires system administration permission. In-progress tasks are not canceled.")
      .setInternal(true)
      .setPost(true)
      .setSince("5.2")
      .setHandler(this);
  }

  @Override
  public void handle(Request wsRequest, Response wsResponse) {
    userSession.checkGlobalPermission(UserRole.ADMIN);
    queue.cancelAll();
    wsResponse.noContent();
  }
}
