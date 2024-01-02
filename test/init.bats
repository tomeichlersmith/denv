#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  go_to_tmp_work
}

teardown() {
  clean_tmp_work
}

@test "no init denv should fail" {
  run denv
  assert_failure
  assert_output --partial "Unable to deduce a denv workspace"
}

@test "denv can init" {
  run denv init ubuntu:22.04
  assert_success
}

@test "denv should not init twice" {
  run denv init ubuntu:22.04
  assert_success
  run denv init ubuntu:22.04
  assert_failure
}
