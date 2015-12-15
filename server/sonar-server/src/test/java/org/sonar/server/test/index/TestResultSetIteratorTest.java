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
package org.sonar.server.test.index;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import org.elasticsearch.action.update.UpdateRequest;
import org.junit.After;
import org.junit.Rule;
import org.junit.Test;
import org.junit.experimental.categories.Category;
import org.sonar.api.utils.System2;
import org.sonar.db.DbTester;
import org.sonar.db.protobuf.DbFileSources;
import org.sonar.server.source.index.FileSourcesUpdaterHelper;
import org.sonar.server.test.db.TestTesting;
import org.sonar.test.DbTests;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.fail;
import static org.assertj.core.data.MapEntry.entry;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_COVERED_FILES;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_DURATION_IN_MS;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_FILE_UUID;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_MESSAGE;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_NAME;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_PROJECT_UUID;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_STACKTRACE;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_STATUS;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_TEST_UUID;
import static org.sonar.server.test.index.TestIndexDefinition.FIELD_UPDATED_AT;

@Category(DbTests.class)
public class TestResultSetIteratorTest {

  @Rule
  public DbTester dbTester = DbTester.create(System2.INSTANCE);

  TestResultSetIterator underTest;

  private static List<DbFileSources.Test> newFakeTests(int numberOfTests) {
    List<DbFileSources.Test> tests = new ArrayList<>();
    for (int i = 1; i <= numberOfTests; i++) {
      DbFileSources.Test.Builder test = DbFileSources.Test.newBuilder()
        .setUuid("TEST_FILE_UUID_" + i)
        .setName("NAME_" + i)
        .setStatus(DbFileSources.Test.TestStatus.FAILURE)
        .setStacktrace("STACKTRACE_" + i)
        .setMsg("MESSAGE_" + i)
        .setExecutionTimeMs(i);
      for (int j = 1; j <= numberOfTests; j++) {
        test.addCoveredFile(
          DbFileSources.Test.CoveredFile.newBuilder()
            .setFileUuid("MAIN_FILE_UUID_" + j)
            .addCoveredLine(j));
      }
      tests.add(test.build());
    }
    return tests;
  }

  @After
  public void after() {
    if (underTest != null) {
      underTest.close();
    }
  }

  @Test
  public void traverse_db() throws Exception {
    dbTester.prepareDbUnit(getClass(), "shared.xml");
    TestTesting.updateDataColumn(dbTester.getSession(), "F1", newFakeTests(3));
    underTest = TestResultSetIterator.create(dbTester.getDbClient(), dbTester.getSession(), 0L, null);

    FileSourcesUpdaterHelper.Row row = underTest.next();
    assertThat(row.getProjectUuid()).isEqualTo("P1");
    assertThat(row.getFileUuid()).isEqualTo("F1");
    assertThat(row.getUpdatedAt()).isEqualTo(1416239042000L);
    assertThat(row.getUpdateRequests()).hasSize(3);

    UpdateRequest firstRequest = row.getUpdateRequests().get(0);
    Map<String, Object> doc = firstRequest.doc().sourceAsMap();
    assertThat(doc).contains(
      entry(FIELD_PROJECT_UUID, "P1"),
      entry(FIELD_FILE_UUID, "F1"),
      entry(FIELD_TEST_UUID, "TEST_FILE_UUID_1"),
      entry(FIELD_STATUS, "FAILURE"),
      entry(FIELD_MESSAGE, "MESSAGE_1"),
      entry(FIELD_DURATION_IN_MS, 1),
      entry(FIELD_STACKTRACE, "STACKTRACE_1"),
      entry(FIELD_NAME, "NAME_1"),
      entry(FIELD_UPDATED_AT, 1416239042000L));
  }

  /**
   * File with one line. No metadata available on the line.
   */
  @Test
  public void minimal_data() throws Exception {
    dbTester.prepareDbUnit(getClass(), "shared.xml");
    List<DbFileSources.Test> tests = Arrays.asList(
      DbFileSources.Test.newBuilder()
        .setUuid("U1")
        .setName("N1")
        .build());
    TestTesting.updateDataColumn(dbTester.getSession(), "F1", tests);
    underTest = TestResultSetIterator.create(dbTester.getDbClient(), dbTester.getSession(), 0L, null);

    FileSourcesUpdaterHelper.Row row = underTest.next();

    assertThat(row.getProjectUuid()).isEqualTo("P1");
    assertThat(row.getFileUuid()).isEqualTo("F1");
    assertThat(row.getUpdatedAt()).isEqualTo(1416239042000L);
    assertThat(row.getUpdateRequests()).hasSize(1);
    UpdateRequest firstRequest = row.getUpdateRequests().get(0);
    Map<String, Object> doc = firstRequest.doc().sourceAsMap();
    assertThat(doc).contains(
      entry(FIELD_PROJECT_UUID, "P1"),
      entry(FIELD_FILE_UUID, "F1"),
      entry(FIELD_TEST_UUID, "U1"),
      entry(FIELD_NAME, "N1"),
      entry(FIELD_UPDATED_AT, 1416239042000L));
    ;
    // null values
    assertThat(doc).containsKeys(
      FIELD_DURATION_IN_MS,
      FIELD_STACKTRACE,
      FIELD_MESSAGE,
      FIELD_STATUS,
      FIELD_COVERED_FILES);
  }

  @Test
  public void filter_by_date() {
    dbTester.prepareDbUnit(getClass(), "shared.xml");
    underTest = TestResultSetIterator.create(dbTester.getDbClient(), dbTester.getSession(), 2000000000000L, null);

    assertThat(underTest.hasNext()).isFalse();
  }

  @Test
  public void filter_by_project() throws Exception {
    dbTester.prepareDbUnit(getClass(), "filter_by_project.xml");
    TestTesting.updateDataColumn(dbTester.getSession(), "F1", newFakeTests(1));

    underTest = TestResultSetIterator.create(dbTester.getDbClient(), dbTester.getSession(), 0L, "P1");

    FileSourcesUpdaterHelper.Row row = underTest.next();
    assertThat(row.getProjectUuid()).isEqualTo("P1");
    assertThat(row.getFileUuid()).isEqualTo("F1");

    // File from other project P2 is not returned
    assertThat(underTest.hasNext()).isFalse();
  }

  @Test
  public void filter_by_project_and_date() throws Exception {
    dbTester.prepareDbUnit(getClass(), "filter_by_project_and_date.xml");
    TestTesting.updateDataColumn(dbTester.getSession(), "F1", newFakeTests(1));

    underTest = TestResultSetIterator.create(dbTester.getDbClient(), dbTester.getSession(), 1400000000000L, "P1");

    FileSourcesUpdaterHelper.Row row = underTest.next();
    assertThat(row.getProjectUuid()).isEqualTo("P1");
    assertThat(row.getFileUuid()).isEqualTo("F1");

    // File F2 is not returned
    assertThat(underTest.hasNext()).isFalse();
  }

  @Test
  public void fail_on_bad_data_format() throws Exception {
    dbTester.prepareDbUnit(getClass(), "shared.xml");

    TestTesting.updateDataColumn(dbTester.getSession(), "F1", "THIS_IS_NOT_PROTOBUF".getBytes());

    underTest = TestResultSetIterator.create(dbTester.getDbClient(), dbTester.getSession(), 0L, null);
    try {
      assertThat(underTest.hasNext()).isTrue();
      underTest.next();
      fail("it should not be possible to go through not compliant data");
    } catch (IllegalStateException e) {
      // ok
    }
  }

}
