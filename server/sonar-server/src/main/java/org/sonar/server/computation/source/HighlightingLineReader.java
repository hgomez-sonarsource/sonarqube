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
package org.sonar.server.computation.source;

import com.google.common.collect.ImmutableMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.CheckForNull;
import org.sonar.api.utils.log.Logger;
import org.sonar.api.utils.log.Loggers;
import org.sonar.batch.protocol.Constants;
import org.sonar.batch.protocol.output.BatchReport;
import org.sonar.db.protobuf.DbFileSources;
import org.sonar.server.computation.component.Component;
import org.sonar.server.computation.source.RangeOffsetConverter.RangeOffsetConverterException;

import static com.google.common.collect.Lists.newArrayList;
import static java.lang.String.format;
import static org.sonar.server.computation.source.RangeOffsetConverter.OFFSET_SEPARATOR;
import static org.sonar.server.computation.source.RangeOffsetConverter.SYMBOLS_SEPARATOR;

public class HighlightingLineReader implements LineReader {

  private static final Logger LOG = Loggers.get(HighlightingLineReader.class);

  private boolean isHighlightingValid = true;

  private static final Map<Constants.HighlightingType, String> cssClassByType = ImmutableMap.<Constants.HighlightingType, String>builder()
    .put(Constants.HighlightingType.ANNOTATION, "a")
    .put(Constants.HighlightingType.CONSTANT, "c")
    .put(Constants.HighlightingType.COMMENT, "cd")
    .put(Constants.HighlightingType.CPP_DOC, "cppd")
    .put(Constants.HighlightingType.STRUCTURED_COMMENT, "j")
    .put(Constants.HighlightingType.KEYWORD, "k")
    .put(Constants.HighlightingType.KEYWORD_LIGHT, "h")
    .put(Constants.HighlightingType.HIGHLIGHTING_STRING, "s")
    .put(Constants.HighlightingType.PREPROCESS_DIRECTIVE, "p")
    .build();

  private final Component file;
  private final Iterator<BatchReport.SyntaxHighlighting> lineHighlightingIterator;
  private final RangeOffsetConverter rangeOffsetConverter;
  private final List<BatchReport.SyntaxHighlighting> highlightingList;

  private BatchReport.SyntaxHighlighting currentItem;

  public HighlightingLineReader(Component file, Iterator<BatchReport.SyntaxHighlighting> lineHighlightingIterator, RangeOffsetConverter rangeOffsetConverter) {
    this.file = file;
    this.lineHighlightingIterator = lineHighlightingIterator;
    this.rangeOffsetConverter = rangeOffsetConverter;
    this.highlightingList = newArrayList();
  }

  @Override
  public void read(DbFileSources.Line.Builder lineBuilder) {
    if (!isHighlightingValid) {
      return;
    }
    try {
      processHighlightings(lineBuilder);
    } catch (RangeOffsetConverterException e) {
      isHighlightingValid = false;
      LOG.warn(format("Inconsistency detected in Highlighting data. Highlighting will be ignored for file '%s'", file.getKey()), e);
    }
  }

  private void processHighlightings(DbFileSources.Line.Builder lineBuilder) {
    int line = lineBuilder.getLine();
    StringBuilder highlighting = new StringBuilder();

    incrementHighlightingListMatchingLine(line);
    for (Iterator<BatchReport.SyntaxHighlighting> syntaxHighlightingIterator = highlightingList.iterator(); syntaxHighlightingIterator.hasNext();) {
      processHighlighting(syntaxHighlightingIterator, highlighting, lineBuilder);
    }
    if (highlighting.length() > 0) {
      lineBuilder.setHighlighting(highlighting.toString());
    }
  }

  private void processHighlighting(Iterator<BatchReport.SyntaxHighlighting> syntaxHighlightingIterator, StringBuilder highlighting,
    DbFileSources.Line.Builder lineBuilder) {
    BatchReport.SyntaxHighlighting syntaxHighlighting = syntaxHighlightingIterator.next();
    int line = lineBuilder.getLine();
    BatchReport.TextRange range = syntaxHighlighting.getRange();
    if (range.getStartLine() <= line) {
      String offsets = rangeOffsetConverter.offsetToString(syntaxHighlighting.getRange(), line, lineBuilder.getSource().length());
      if (offsets.isEmpty()) {
        syntaxHighlightingIterator.remove();
      } else {
        if (highlighting.length() > 0) {
          highlighting.append(SYMBOLS_SEPARATOR);
        }
        highlighting.append(offsets)
          .append(OFFSET_SEPARATOR)
          .append(getCssClass(syntaxHighlighting.getType()));
        if (range.getEndLine() == line) {
          syntaxHighlightingIterator.remove();
        }
      }
    }
  }

  private static String getCssClass(Constants.HighlightingType type) {
    String cssClass = cssClassByType.get(type);
    if (cssClass != null) {
      return cssClass;
    } else {
      throw new IllegalArgumentException(format("Unknown type %s ", type.toString()));
    }
  }

  private void incrementHighlightingListMatchingLine(int line) {
    BatchReport.SyntaxHighlighting syntaxHighlighting = getNextHighlightingMatchingLine(line);
    while (syntaxHighlighting != null) {
      highlightingList.add(syntaxHighlighting);
      this.currentItem = null;
      syntaxHighlighting = getNextHighlightingMatchingLine(line);
    }
  }

  @CheckForNull
  private BatchReport.SyntaxHighlighting getNextHighlightingMatchingLine(int line) {
    // Get next element (if exists)
    if (currentItem == null && lineHighlightingIterator.hasNext()) {
      currentItem = lineHighlightingIterator.next();
    }
    // Return current element if lines match
    if (currentItem != null && currentItem.getRange().getStartLine() == line) {
      return currentItem;
    }
    return null;
  }

}
