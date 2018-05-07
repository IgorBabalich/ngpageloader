// Copyright 2017 Google Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:pageloader/pageloader.dart';
import 'package:test/test.dart';

import 'shared_page_objects.dart';

part 'annotations.g.dart';

typedef PageLoaderElement GetNewContext();

void runTests(GetNewContext contextGenerator) {
  group('annotations', () {
    test('CheckTag annotation', () async {
      final base = new BaseObject.create(contextGenerator());
      expect(base.table.table.name, 'table');
      await verifyRows(base.table.rows);
    });

    test('EnsureTag annotation', () async {
      final base = new BaseEnsureObject.create(contextGenerator());
      expect(base.table.table.name, 'table');
      await verifyRows(base.table.rows);
    });

    test('CheckTag annotation fails as expected', () async {
      final base = new BaseObject.create(contextGenerator());
      try {
        base.badTable.table.name;
        fail('Expected to throw on bad @CheckTag');
      } catch (e) {
        expect(
            e.toString(), contains('Failed check: @CheckTag("inconceivable")'));
      }
    });

    test('EnsureTag annotation fails as expected', () async {
      final base = new BaseEnsureObject.create(contextGenerator());
      try {
        base.badTable.table.name;
        fail('Expected to throw on bad @EnsureTag');
      } catch (e) {
        expect(e.toString(), contains('Found 0 elements in _single'));
      }
    });

    test('Global top ', () async {
      final base = new BaseObject.create(contextGenerator());
      expect(base.globalTable.name, 'table');
    });

    test('Global nested', () async {
      final base = new BaseObject.create(contextGenerator());
      expect(base.table.globalTable.name, 'table');
    });

    test('WithAttribute', () async {
      final page = new PageForWithAttributeTest.create(contextGenerator());
      expect(page.element.attributes['type'], 'checkbox');
    });

    test('WithClass', () async {
      final page = new PageForWithClassTest.create(contextGenerator());
      expect(page.element.attributes['type'], 'checkbox');
      expect(page.element.classes,
          unorderedEquals(['with-class-test', 'class1', 'class2']));
    });

    test('DebugId', () async {
      final page = new DebugIds.create(contextGenerator());
      expect(page.option1.innerText, 'option 1');
      expect(page.option2.innerText, 'option 2');
    });
  });

  group('custom annotations', () {
    test('CheckTag annotation', () async {
      final base = new PseudoBaseObject.create(contextGenerator());
      expect(base.table.table.name, 'table');
      await verifyRows(base.table.rows);
    });

    test('CheckTag annotation fails as expected', () async {
      final base = new PseudoBaseObject.create(contextGenerator());
      try {
        base.badTable.table.name;
        fail('Expected to throw on bad @CheckTag');
      } catch (e) {
        expect(
            e.toString(), contains('Failed check: @CheckTag("inconceivable")'));
      }
    });

    test('Global top ', () async {
      final base = new PseudoBaseObject.create(contextGenerator());
      expect(base.globalTable.name, 'table');
    });

    test('Global nested', () async {
      final base = new PseudoBaseObject.create(contextGenerator());
      expect(base.table.globalTable.name, 'table');
    });
  });
}

@PageObject()
abstract class BaseObject {
  BaseObject();
  factory BaseObject.create(PageLoaderElement context) = $BaseObject.create;

  @ByTagName('table')
  TableForCheckTag get table;

  @Global(const ByTagName('table'))
  PageLoaderElement get globalTable;

  @ByTagName('table')
  CheckTagFails get badTable;
}

@PageObject()
abstract class PseudoBaseObject {
  PseudoBaseObject();
  factory PseudoBaseObject.create(PageLoaderElement context) =
      $PseudoBaseObject.create;

  @PseudoByTagName('table')
  TableForCheckTag get table;

  @Global(const PseudoByTagName('table'))
  PageLoaderElement get globalTable;

  @PseudoByTagName('table')
  CheckTagFails get badTable;
}

@CheckTag('table')
@PageObject()
abstract class TableForCheckTag {
  TableForCheckTag();
  factory TableForCheckTag.create(PageLoaderElement context) =
      $TableForCheckTag.create;

  @root
  PageLoaderElement get table;

  @Global(const ByTagName('table'))
  PageLoaderElement get globalTable;

  @ByTagName('tr')
  PageObjectIterable<Row> get rows;
}

@PageObject()
abstract class BaseEnsureObject {
  BaseEnsureObject();
  factory BaseEnsureObject.create(PageLoaderElement context) =
      $BaseEnsureObject.create;

  @ByTagName('table')
  TableForEnsureTag get table;

  @ByTagName('table')
  EnsureTagFails get badTable;
}

@EnsureTag('table')
@PageObject()
abstract class TableForEnsureTag {
  TableForEnsureTag();
  factory TableForEnsureTag.create(PageLoaderElement context) =
      $TableForEnsureTag.create;

  @root
  PageLoaderElement get table;

  @ByTagName('tr')
  PageObjectIterable<Row> get rows;
}

@CheckTag('inconceivable')
@PageObject()
abstract class CheckTagFails {
  CheckTagFails();
  factory CheckTagFails.create(PageLoaderElement context) =
      $CheckTagFails.create;

  @root
  PageLoaderElement get table;
}

@EnsureTag('inconceivable')
@PageObject()
abstract class EnsureTagFails {
  EnsureTagFails();
  factory EnsureTagFails.create(PageLoaderElement context) =
      $EnsureTagFails.create;

  @root
  PageLoaderElement get table;
}

@PageObject()
abstract class PageForWithAttributeTest {
  PageForWithAttributeTest();
  factory PageForWithAttributeTest.create(PageLoaderElement context) =
      $PageForWithAttributeTest.create;

  @ByTagName('input')
  @WithAttribute('type', 'checkbox')
  PageLoaderElement get element;
}

@PageObject()
abstract class PageForWithClassTest {
  PageForWithClassTest();
  factory PageForWithClassTest.create(PageLoaderElement context) =
      $PageForWithClassTest.create;

  @ByTagName('input')
  @WithClass('with-class-test')
  PageLoaderElement get element;
}

@PageObject()
abstract class DebugIds {
  DebugIds();
  factory DebugIds.create(PageLoaderElement context) = $DebugIds.create;

  @ByDebugId('option')
  PageLoaderElement get option1;

  @ByDebugId('option', useDash: true)
  PageLoaderElement get option2;
}

class PseudoByTagName implements CssFinder {
  final String _tagName;

  const PseudoByTagName(this._tagName);

  @override
  String get cssSelector => _tagName;

  @override
  String toString() => '@PseudoByTagName("$_tagName")';
}