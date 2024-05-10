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
  # `-c` is the short for --format for GNU coreutils
  # `-f` is the equivalent for BSD
  # we can detect which stat we are using by testing
  # for the GNU flag
  if ! stat -c "%u:%g" file-from-denv > file-from-denv-ownership; then
    stat -f "%u:%g" file-from-denv > file-from-denv-ownership
  fi
  correct="$(id -u ${USER}):$(id -g ${USER})"
  assert_equal "$(cat file-from-denv-ownership)" "$(id -u ${USER}):$(id -g ${USER})"
}
