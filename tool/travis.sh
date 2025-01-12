#!/bin/bash

# Copyright 2013 Google Inc. All Rights Reserved.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

STATUS=0

# Analyze package.
dartanalyzer .
ANALYSIS_STATUS=$?
if [[ $ANALYSIS_STATUS -ne 0 ]]; then
  STATUS=$ANALYSIS_STATUS
  echo "Analysis step ended with non-zero status: $STATUS"
fi

# Run non-html and non-webdriver tests
core_tests=("test/core_method_information_test.dart" \
            "test/correct_gen_test.dart" \
            "test/correct_gen_null_safety_test.dart" \
            "test/matchers_test.dart" \
            "test/utils_test.dart")

for test in ${core_tests[@]}
do
  dart test -r expanded "$test"
  TEST_STATUS=$?
  if [[ $TEST_STATUS -ne 0 ]]; then
    STATUS=$TEST_STATUS
    echo "Test($test) ended with non-zero status: $STATUS"
  fi
done

# Run test creator tests
test_creator_tests=("test/test_creator_getters_test.dart" \
                    "test/test_creator_getters_null_safety_test.dart" \
                    "test/test_creator_invoke_method_test.dart" \
                    "test/test_creator_invoke_method_null_safety_test.dart" \
                    "test/test_creator_methods_test.dart" \
                    "test/test_creator_methods_null_safety_test.dart")
for test in ${test_creator_tests[@]}
do
  dart test -r expanded "$test"
  TEST_STATUS=$?
  if [[ $TEST_STATUS -ne 0 ]]; then
    STATUS=$TEST_STATUS
    echo "Test($test) ended with non-zero status: $STATUS"
  fi
done

# Run html tests
html_tests="$(find test -type f -name "html_*_test.dart")"

for test in ${html_tests[@]}
do
  dart test -r expanded -p chrome "$test"
  TEST_STATUS=$?
  if [[ $TEST_STATUS -ne 0 ]]; then
    STATUS=$TEST_STATUS
    echo "Test($test) ended with non-zero status: $STATUS"
  fi
done

# Run webdriver tests

# Start chromedriver.
chromedriver --port=4444 --url-base=wd/hub &
PID=$!

wd_tests="$(find test -type f -name "webdriver_*_test.dart")"

for test in ${wd_tests[@]}
do
  dart test -r expanded -p vm "$test"
  TEST_STATUS=$?
  if [[ $TEST_STATUS -ne 0 ]]; then
    STATUS=$TEST_STATUS
    echo "Test($test) ended with non-zero status: $STATUS"
  fi
done

# Exit chromedriver.
kill $PID

exit $STATUS
