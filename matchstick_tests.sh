#!/bin/bash

# REPOSITORY: https://github.com/alwyn974/matchstick_tests

################
#              #
#    Colors    #
#              #
################

ESC='\033['
NC="${ESC}0m"
RED="${ESC}0;31m"
GREEN="${ESC}0;32m"

function printColor() {
  echo -e "${1}${NC}"
}

BINARY_NAME=matchstick
PASSED=""
FAILED=""

function tests() {
  echo -e "Testing matchstick..."

  echo -e "\nTesting invalid line argument..."
  expect_exit_code 84 0 0
  expect_exit_code 84 -1 0
  expect_exit_code 84 1 0
  expect_exit_code 84 -124898 0
  expect_exit_code 84 100 0
  expect_exit_code 84 aze 0
  expect_exit_code 84 -aze 0
  expect_exit_code 84 +854aze 0
  expect_exit_code 84 /*+azeaz 0
  expect_exit_code 84 100 0

  echo -e "\nTesting valid line argument..."
  expect_exit_code 0 99 1
  expect_exit_code 0 2 1
  expect_exit_code 0 50 1
  expect_exit_code 0 9 1

  echo -e "\nTesting invalid matches argument..."
  expect_exit_code 84 2 0
  expect_exit_code 84 2 coucou
  expect_exit_code 84 2 +59489
  expect_exit_code 84 2 -152
  expect_exit_code 84 2 -7547548634864

  echo -e "\nTesting valid matches argument..."
  expect_exit_code 0 2 1
  expect_exit_code 0 2 5
  expect_exit_code 0 2 9
  expect_exit_code 0 2 412045
  expect_exit_code 0 2 7758

  echo -e "\nTesting random values in getline"
  expect_exit_code 0 4 5 "1"
  expect_exit_code 0 4 5 "&\n&"
  expect_exit_code 0 4 5 "&\n$\n*\n9\n52"
  expect_exit_code 0 4 5 "^3\n&é"
  expect_exit_code 0 4 5 "\n"
  expect_exit_code 0 4 5 "1\n"
  expect_exit_code 0 4 5 "1\n1"

  echo -e "\nTesting lose..."
  expect_exit_code 1 2 1 "1\n1\n2\n1"

  echo -e "\nTesting win..."
  expect_exit_code 2 2 2 "2\n2\n2\n1"
  echo "If this fail it can be normal check the map"
  expect_exit_code 2 2 2 "2\n2\n1\n1"
  echo "If this fail it can be normal check the map"
}

function fail() {
  printColor "${RED}Failed: $*"
  FAILED+=1
}

function pass() {
  printColor "${GREEN}Passed"
  PASSED+=1
}

function expect_exit_code() {
  local expected_code="$1"
  local arg1="$2"
  local arg2="$3"
  shift
  shift
  shift
  echo ""
  echo "echo \"$*\" | ./matchstick $arg1 $arg2"
  echo "-----"
  echo "Expectation: Exit code must be $expected_code"
  echo "---"
  EXIT1=$expected_code

  echo -ne "$@" | ./$BINARY_NAME "$arg1" "$arg2"
  EXIT2=$?

  if [ "$EXIT1" != "$EXIT2" ]; then
    fail "Exit code are different (expected $EXIT1, got $EXIT2)."
    return
  fi
  pass
}

function check_binary() {
  if [ ! -f "./matchstick" ]; then
    echo "./$BINARY_NAME not found !"
    exit 1
  fi
}

function total() {
  echo -e "\nTests passed: $(echo -n $PASSED | wc -m). Tests failed: $(echo -n $FAILED | wc -m)."
}

function main() {
  check_binary
  tests
  total
}

main
