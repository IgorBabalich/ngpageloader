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

import 'package:ngpageloader/pageloader.dart';
import 'package:webdriver/sync_core.dart' as wd;

import 'webdriver_page_loader_element.dart';

/// Iterator for [WebDriverPageLoaderElement]s.
class WebDriverPageElementIterator
    extends Iterator<WebDriverPageLoaderElement> {
  final Iterator<wd.WebElement> _elements;

  WebDriverPageElementIterator(List<wd.WebElement> elements)
      : _elements = elements.iterator;

  @override
  bool moveNext() => _elements.moveNext();

  @override
  WebDriverPageLoaderElement get current {
    return WebDriverPageLoaderElement.createFromElement(_elements.current);
  }
}

/// Iterable for [WebDriverPageElementIterable]s.
///
/// Note every call to the iterables has the potential to refresh the set of
/// elements, but the returned [WebDriverPageElementIterator] is based on the
/// set of elements found when the iterator was created.
class WebDriverPageElementIterable extends PageElementIterable {
  final WebDriverPageLoaderElement _drivingElement;

  WebDriverPageElementIterable(this._drivingElement);

  @override
  Future<PageLoaderElement> get first async =>
      WebDriverPageLoaderElement.createFromElement(_drivingElement.elements[0]);

  @override
  Future<Iterator<PageLoaderElement>> get iterator async {
    return WebDriverPageElementIterator(_drivingElement.elements);
  }

  @override
  Future<int> get length async {
    return _drivingElement.elements.length;
  }
}
