#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  
  go_to_tmp_work
  denv init ubuntu:22.04
}

teardown() {
  clean_tmp_work
}

@test "whoami matches inside and outside denv" {
  run denv whoami
  assert_success
  assert_container_output "$(whoami)"
}

@test "file created inside denv has id match" {
  run denv touch file-from-denv
  assert_equal "$(stat -c %u file-from-denv)" "$(id -u ${USER})"
  assert_equal "$(stat -c %g file-from-denv)" "$(id -g ${USER})"
}
