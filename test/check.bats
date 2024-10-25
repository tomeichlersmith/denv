#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  
  go_to_tmp_work
}

teardown() {
  clean_tmp_work
}

@test "basic check run" {
  run -0 denv check
  assert_output --partial "denv would run with '${DENV_RUNNER}'"
}

@test "quiet check run" {
  run -0 denv check --quiet
  refute_output
}

@test "quiet but not silent check run" {
  run -4 denv check --workspace --quiet
  assert_output
  run -0 denv init alpine:latest
  run -0 denv check --workspace --quiet
  refute_output
}

@test "silent check run" {
  run -4 denv check --workspace --silent
  refute_output
}

@test "check fails when using unsupported runner" {
  export DENV_RUNNER=dne
  run -3 denv check
  assert_output --partial "runner is not supported by denv"
}

@test "check that we are in a workspace" {
  run -0 denv init alpine:latest
  run -0 denv check --workspace
  assert_output --partial "Found denv_workspace"
}

@test "check that we are not in a workspace" {
  run -4 denv check --workspace
  assert_output --partial "Unable to deduce a denv workspace"
}

