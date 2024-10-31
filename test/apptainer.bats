#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  
  go_to_tmp_work
  denv init alpine:latest
}

teardown() {
  clean_tmp_work
}

# bats file_tags=apptainer

@test "normal running works" {
  run -0 denv true
  assert_success
}

@test "can invalidate cache and then run" {
  rm -r ${APPTAINER_CACHEDIR}
  run -0 denv true
  assert_success
}
