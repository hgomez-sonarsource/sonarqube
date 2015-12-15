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
package org.sonar.server.text;

import org.sonar.api.server.ServerSide;
import org.sonar.markdown.Markdown;

/**
 * @since 3.6
 */
@ServerSide
public class RubyTextService {

  private final MacroInterpreter macroInterpreter;

  public RubyTextService(MacroInterpreter macroInterpreter) {
    this.macroInterpreter = macroInterpreter;
  }

  // TODO add ruby example
  public String interpretMacros(String text) {
    return macroInterpreter.interpret(text);
  }

  // TODO add ruby example
  public String markdownToHtml(String markdown) {
    return Markdown.convertToHtml(markdown);
  }
}
