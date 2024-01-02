#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  go_to_tmp_work
}

teardown() {
  clean_tmp_work
}

# bats file_tags=norunner

@test "no init denv should fail" {
  run denv
  assert_failure
  assert_output --partial "Unable to deduce a denv workspace"
}

@test "can print denv help without a denv" {
  run denv help
  assert_success
  assert_output
}

@test "can print denv init help without a denv" {
  run denv init help
  assert_success
  assert_output
}

@test "can print denv config help without a denv" {
  run denv config help
  assert_success
  assert_output
}

@test "can print denv config env help without a denv" {
  run denv config env help
  assert_success
  assert_output
}

@test "denv can init" {
  run denv init ubuntu:22.04
  assert_success
  assert_file_contains .denv/config "^denv_name=\"$(basename ${PWD})\"$"
  assert_file_contains .denv/config '^denv_image="ubuntu:22\.04"$'
  assert_file_contains .denv/config '^denv_shell="/bin/bash -i"$'
  assert_file_contains .denv/config '^denv_mounts=""$'
  assert_file_contains .denv/config '^denv_env_var_copy_all="true"$'
  assert_file_contains .denv/config '^denv_env_var_copy=""$'
  assert_file_contains .denv/config '^denv_env_var_set=""$'
}

@test "denv should not init twice" {
  run denv init ubuntu:22.04
  assert_success
  run ! denv init ubuntu:22.04
  assert_failure
  # but can be forced
  run -0 denv init --force ubuntu:20.04
  assert_success
  assert_file_contains .denv/config '^denv_image="ubuntu:20\.04"$'
}
