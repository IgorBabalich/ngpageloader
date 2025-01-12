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

import 'dart:core';
import 'dart:math';

import 'package:ngpageloader/pageloader.dart';

/// Concrete implementations for use in code generation tests, mostly via
/// toString().

class DummyListener extends PageLoaderListener {
  final List<String> values = <String>[];

  @override
  void startPageObjectMethod(String pageObjectName, String methodName) {
    values.add('$pageObjectName.$methodName');
  }
}

class DummyPageLoaderMouse implements PageLoaderMouse {
  @override
  String toString() => 'DummyMouse';

  @override
  Future<Null> down(MouseButton button,
          {PageLoaderElement? eventTarget, ClickOption? clickOption}) =>
      throw 'what';

  @override
  Future<Null> up(MouseButton button,
          {PageLoaderElement? eventTarget, ClickOption? clickOption}) =>
      throw 'no';

  @override
  Future<Null> moveTo(PageLoaderElement element, int? xOffset, int? yOffset,
          {List<PageLoaderElement>? dispatchTo,
          int? stepPixels,
          Duration? duration}) =>
      throw 'can not even';
}

class DummyPageLoaderPointer implements PageLoaderPointer {
  @override
  String toString() => 'DummyPointer';

  @override
  Future<Null> down(MouseButton button, {PageLoaderElement? eventTarget}) =>
      throw 'not implemented';

  @override
  Future<Null> up(MouseButton button, {PageLoaderElement? eventTarget}) =>
      throw 'not implemented';

  @override
  Future<Null> moveTo(PageLoaderElement element, int? xOffset, int? yOffset,
          {List<PageLoaderElement>? dispatchTo,
          int? stepPixels,
          Duration? duration}) =>
      throw 'not implemented';
}

class DummyPageLoader extends PageUtils {
  @override
  PageLoaderElement get root => throw 'not implemented';

  @override
  PageLoaderElement get focused => throw 'not implemented';

  @override
  PageLoaderElement byTag(String tag) => throw 'not implemented';

  @override
  PageLoaderMouse get mouse => DummyPageLoaderMouse();

  @override
  PageLoaderPointer get pointer => DummyPageLoaderPointer();
}

class DummyPageElementIterable extends PageElementIterable {
  final List<Finder> _finders;

  DummyPageElementIterable(this._finders);

  @override
  String toString() => _finders.join(' ');

  @override
  Future<PageLoaderElement> get first => throw 'not implemented';

  @override
  Future<Iterator<DummyPageLoaderElement>> get iterator =>
      throw 'not implemented';

  @override
  Future<int> get length => throw 'not implemented';
}

class DummyPageLoaderElement implements PageLoaderElement {
  final List<Finder> _finders;
  final List<Filter> _filter;
  final List<Checker> _checkers;
  final List<PageLoaderListener> _listeners;

  final bool _exists;
  final bool _focused;
  final bool _displayed;
  final _classes = <String>[];

  DummyPageLoaderElement(
      {bool exists = true,
      bool displayed = true,
      bool focused = true,
      List<String> classes = const <String>[]})
      : _exists = exists,
        _displayed = displayed,
        _focused = focused,
        _finders = <Finder>[],
        _filter = <Filter>[],
        _checkers = <Checker>[],
        _listeners = <PageLoaderListener>[] {
    _classes.addAll(classes);
  }

  @override
  String toString() => [
        _finders.join(' '),
        _filter.join(' '),
        _checkers.join(' ')
      ].join(' ').trim();

  @override
  PageLoaderElement createElement(
      Finder finder, List<Filter> filter, List<Checker> checkers) {
    final newElement = DummyPageLoaderElement();
    newElement._finders.addAll(_finders);
    newElement._finders.add(finder);
    newElement._filter.addAll(filter);
    newElement._checkers.addAll(checkers);
    newElement._listeners.addAll(_listeners);
    return newElement;
  }

  @override
  PageElementIterable createIterable(
      Finder finder, List<Filter> filter, List<Checker> checkers) {
    final finders = <Finder>[];
    finders.addAll(_finders);
    finders.add(finder);
    return DummyPageElementIterable(finders);
  }

  @override
  List<PageLoaderElement> createList(
      Finder finder, List<Filter> filter, List<Checker> checkers) {
    final newElement = DummyPageLoaderElement();
    newElement._finders.addAll(_finders);
    newElement._finders.add(finder);
    newElement._filter.addAll(filter);
    newElement._checkers.addAll(checkers);
    newElement._listeners.addAll(_listeners);
    return [newElement];
  }

  @override
  void addCheckers(List<Checker> checkers) {
    _checkers.addAll(checkers);
  }

  @override
  void addListeners(List<PageLoaderListener> listeners) {
    _listeners.addAll(listeners);
  }

  @override
  List<PageLoaderListener> get listeners => _listeners;

  @override
  dynamic get context => '';

  @override
  dynamic get contextSync => '';

  @override
  PageUtils get utils => DummyPageLoader();

  @override
  DummyPageLoaderElement get shadowRoot => throw 'not implemented';

  @override
  List<PageLoaderElement> get shadowRootChildren => throw 'not implemented';

  @override
  String get innerText => throw 'not implemented';

  @override
  String get visibleText => throw 'not implemented';

  @override
  String get name => throw 'not implemented';

  @override
  PageLoaderAttributes get attributes => throw 'not implemented';

  @override
  PageLoaderAttributes get seleniumAttributes => throw 'not implemented';

  @override
  PageLoaderAttributes get properties => throw 'not implemented';

  @override
  final PageLoaderAttributes computedStyle = DummyPageLoaderAttributes();

  @override
  PageLoaderAttributes get style => throw 'not implemented';

  @override
  bool get displayed => _displayed;

  @override
  List<String> get classes => _classes;

  @override
  bool get isFocused => _focused;

  @override
  bool get exists => _exists;

  @override
  Rectangle get offset => throw 'not implemented';

  @override
  Rectangle getBoundingClientRect() => throw 'not implemented';

  @override
  List<DummyPageLoaderElement> getElementsByCss(String selector) =>
      throw 'not implemented';

  @override
  DummyPageLoaderElement byTag(String tag) => throw 'not implemented';

  @override
  Future<Null> clear(
          {bool sync = true, bool focusBefore = true, bool blurAfter = true}) =>
      throw 'not implemented';

  @override
  Future<Null> click({ClickOption? clickOption}) => throw 'not implemented';

  @override
  Future<Null> clickOutside() => throw 'not implemented';

  @override
  Future<Null> scroll({int? x, int? y}) => throw 'not implemented';

  @override
  Future<void> scrollIntoView() => throw 'not implemented';

  @override
  Future<Null> type(String keys,
          {bool focusBefore = true, bool blurAfter = true}) =>
      throw 'not implemented';

  @override
  Future<Null> typeSequence(PageLoaderKeyboard keys) => throw 'not implemented';

  @override
  Future<Null> focus() => throw 'not implemented';

  @override
  Future<Null> blur() => throw 'not implemented';

  @override
  Future<void> dispatchCustomEvent(String name, {Object? detail}) =>
      throw 'not implemented';

  @override
  String toStringDeep() => 'DummyPageLoaderElement';

  @override
  String get id => '<id>';

  @override
  String testCreatorGetters() => throw 'not implemented';

  @override
  String testCreatorMethods() => throw 'not implemented';
}

class DummyPageLoaderAttributes implements PageLoaderAttributes {
  final _map = <String, String>{};

  @override
  String? operator [](String name) => _map[name];

  void operator []=(String name, String value) => _map[name] = value;
}
